import 'package:flutter/material.dart';
import 'package:messman/models/message.dart';
import 'package:messman/screens/chat/message_card.dart';

class ChatMessagesList extends StatelessWidget {
  final ScrollController controller;
  ChatMessagesList({this.controller});

  @override
  Widget build(BuildContext context) {
    List<Message> messages = [];
    for (int i = 0; i < 20; i++) {
      messages.add(
        Message(
          id: i,
          text:
              '${i % 2 == 0 ? 'Lorem Ipsum ' : 'Dolar sit mmet'} adipisicing elit. Asperiores, reiciendis $i ',
          senderId: (i / 10).round(),
          sentAt: DateTime.now(),
        ),
      );
    }

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (ctx, i) {
        final card = MessageCard(
          message: messages[i],
        );

        if (i == messages.length - 1) {
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
