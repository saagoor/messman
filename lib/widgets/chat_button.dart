import 'package:flutter/material.dart';
import 'package:messman/screens/chat/chat_screen.dart';
import 'package:messman/services/chat_service.dart';
import 'package:provider/provider.dart';

class ChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatService>(context);
    print(chat.unseenMsgCount);
    return Stack(
      children: [
        IconButton(
          iconSize: 40,
          icon: Image.asset('assets/images/chat.png'),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(ChatScreen.routeName)
                .then((value) => chat.leaveChat());
          },
        ),
        if (chat.unseenMsgCount > 0)
          Positioned(
            right: 0,
            top: 2,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: FittedBox(child: Text('${chat.unseenMsgCount}')),
              ),
            ),
          ),
      ],
    );
  }
}
