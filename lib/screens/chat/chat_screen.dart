import 'package:flutter/material.dart';
import 'package:mess/screens/chat/chat_form.dart';
import 'package:mess/screens/chat/chat_messages_list.dart';
import 'package:mess/screens/chat/members_online_status.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = 'chat';

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 243, 218, 1),
      appBar: AppBar(
        // backgroundColor: Color.fromRGBO(255, 207, 92, 1),
        // backgroundColor: Theme.of(context).primaryColorDar,
        elevation: 0,
        title: MembersOnlineStatus(),
      ),
      body: Stack(
        children: <Widget>[
          ChatMessagesList(controller: controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatForm(controller: controller),
          ),
        ],
      ),
    );
  }
}
