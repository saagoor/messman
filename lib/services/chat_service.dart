import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:http/http.dart' as http;
import 'package:messman/constants.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/models/message.dart';

class ChatService with ChangeNotifier {
  final String token;
  final int messId;

  Channel channel;
  List<Message> messages = [];

  DateTime lastSeen;
  int unseenMsgCount = 0;
  bool fetchedPrevMessages = false;

  ChatService({@required this.token, this.messId}) {
    if (this.messId == null) return;
    initChatChannel().then((value) {
      print('Chat service initiated');
    });
  }

  Future<void> initChatChannel() async {
    await initWebsocket().catchError((error) => print(error));

    channel = await Pusher.subscribe('private-Chat.Mess.$messId')
        .catchError((error) => print(error));

    channel.bind("App\\Events\\NewMessage", (event) {
      final data = json.decode(event.data) as Map<String, dynamic>;
      if (data != null && data['message'] != null) {
        messages.insert(0, Message.fromJson(data['message']));
        playTone("new-message.mp3");
        unseenMsgCount += 1;
        notifyListeners();
      }
    });
  }

  Future<void> initWebsocket() async {
    print('initing websocket');

    try {
      Map<String, String> header = httpHeader(token);
      header['Content-Type'] = 'application/x-www-form-urlencoded';
      // print(header);
      await Pusher.init(
        PUSHER_APP_KEY,
        PusherOptions(
          cluster: PUSHER_APP_CLUSTER,
          auth: PusherAuth(
            domain + 'broadcasting/auth/',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              "Authorization": "Bearer $token"
            },
          ),
        ),
        enableLogging: true,
      );

      await Pusher.connect(
        onConnectionStateChange: (x) async {
          print(x.currentState);
        },
        onError: (x) {
          print("Error: ${x.code} ${x.exception}");
        },
      );
    } catch (error) {
      print(error);
    }
  }

  void leaveChat() {
    lastSeen = DateTime.now();
    unseenMsgCount = 0;
    notifyListeners();
  }

  Future<void> sendMessage(Message message) async {
    messages.insert(0, message);
    notifyListeners();

    playTone("send-message.mp3");

    // Store to the server

    try {
      final response = await http.post(
        baseUrl + 'chat/messages',
        headers: httpHeader(token),
        body: json.encode(message.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        final result = json.decode(response.body);
        if (result != null && result == 1) {
          messages[0].status = "sent";
          return;
        } else {
          handleHttpErrors(response);
        }
      } else {
        handleHttpErrors(response);
        print('Message not sent!');
        messages[0].status = "failed";
        notifyListeners();
      }
    } catch (error) {
      print('Message not sent!');
      messages[0].status = "failed";
      notifyListeners();
      throw error;
    }
  }

  Future<AudioPlayer> playTone(String toneName) async {
    AudioCache cache = new AudioCache(prefix: 'assets/tones/');
    return await cache.play(toneName);
  }

  Future<void> fetchMessages({int page = 1}) async {
    print('Fetching messages');

    try {
      final response = await http.get(
        baseUrl + 'chat/messages',
        headers: httpHeader(token),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Message> tempMessages = [];
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          result['data'].forEach((e) {
            tempMessages.add(Message.fromJson(e));
          });
          if (page == 1) {
            this.messages = tempMessages;
            this.fetchedPrevMessages = true;
          } else {
            this.messages.addAll(tempMessages);
          }
          notifyListeners();
        } else {
          return handleHttpErrors(response);
        }
      } else {
        handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }
}
