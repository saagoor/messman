import 'package:flutter/material.dart';
import 'package:messman/models/message.dart';
import 'package:messman/screens/chat/message_card.dart';
import 'package:messman/services/chat_service.dart';
import 'package:provider/provider.dart';

class ChatMessagesList extends StatelessWidget {
  final ScrollController controller;

  ChatMessagesList({this.controller});

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatService>(context);
    final List<Message> messages = chat.messages;

    print('Rebuilding chat msg list');

    return ListView.builder(
      reverse: true,
      controller: controller,
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (ctx, i) {
        final card = MessageCard(
          message: messages[i],
        );

        if (i == 0) {
          return Column(
            children: <Widget>[
              card,
              SizedBox(height: 60),
            ],
          );
        }
        return card;
      },
    );
  }
}
