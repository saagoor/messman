import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/models/message.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/widgets/user/members_circle_avatar.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  const MessageCard({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sender =
        Provider.of<MembersService>(context).memberById(message.senderId);
    final user = Provider.of<AuthService>(context).user;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: (user?.id != message?.senderId)
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            if (user?.id != message?.senderId) ...[
              Column(
                children: <Widget>[
                  MembersSquareAvatar(
                    imageUrl: sender.imageUrl,
                    firstChar: sender.name[0],
                    radius: 35,
                  ),
                  SizedBox(height: 18),
                ],
              ),
              SizedBox(width: 15),
            ],
            Column(
              crossAxisAlignment: (user?.id != message?.senderId)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: user?.id == sender?.id
                        ? Color.fromRGBO(31, 48, 87, 1)
                        : Colors.white,
                  ),
                  constraints: BoxConstraints(maxWidth: 280),
                  child: Text(
                    message.text ?? '',
                    style: TextStyle(
                      color: user?.id == sender?.id
                          ? Colors.white.withOpacity(0.8)
                          : null,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  DateFormat(' H:m a ').format(message.sentAt),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
