import 'package:flutter/material.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/models/message.dart';
import 'package:messman/screens/chat/chat_form.dart';
import 'package:messman/screens/chat/chat_messages_list.dart';
import 'package:messman/screens/chat/members_online_status.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/chat_service.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = 'chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuthService auth;
  ChatService chat;
  final ScrollController controller = ScrollController();

  void sendMessage(String text) {
    final msg = Message(
      text: text,
      senderId: auth.user.id,
      sentAt: DateTime.now(),
    );

    if ((controller.position.pixels) < (600)) {
      _scrollToBottom();
    }

    chat.sendMessage(msg).catchError((error) => showHttpError(context, error));
  }

  void _scrollToBottom() {
    controller.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);
    chat = Provider.of<ChatService>(context, listen: false);

    // print('Building chat screen');

    if (!chat.fetchedPrevMessages) {
      chat.fetchMessages().catchError((error) => showHttpError(context, error));
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(255, 207, 92, 1),
        // backgroundColor: Theme.of(context).primaryColorDar,
        elevation: 1,
        title: Text('Messages & Notifications'),
        // title: MembersOnlineStatus(),
      ),
      body: Stack(
        children: <Widget>[
          ChatMessagesList(controller: controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatForm(callback: sendMessage),
          ),
        ],
      ),
    );
  }
}
