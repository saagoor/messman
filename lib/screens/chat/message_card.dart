import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/models/message.dart';
import 'package:messman/models/user.dart';
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
    print(message.toJson());
    final sender = Provider.of<MembersService>(context, listen: false)
        .memberById(message.senderId);
    final user = Provider.of<AuthService>(context, listen: false).user;

    if (message.sentAt == null) message.sentAt = DateTime.now();

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
                if (message.status == 'failed')
                  Text(
                    'Failed',
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                buildMessageContainer(user, sender),
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

  Container buildMessageContainer(User user, User sender) {
    Color bgColor =
        user?.id == sender?.id ? Color.fromRGBO(31, 48, 87, 1) : Colors.white;
    Color textColor =
        user?.id == sender?.id ? Colors.white.withOpacity(0.8) : null;

    if (message.type == 'info') {
      bgColor = Color.fromRGBO(242, 243, 246, 1);
      textColor = null;
    } else if (message.type == 'alert') {
      bgColor = Color.fromRGBO(242, 243, 246, 1);
      textColor = null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgColor,
      ),
      constraints: BoxConstraints(maxWidth: 280),
      child: buildMessageContent(textColor),
    );
  }

  buildMessageContent(Color textColor) {
    final text = Text(
      message.text ?? '',
      style: TextStyle(color: textColor),
      overflow: TextOverflow.visible,
    );

    switch (message.type) {
      case 'info':
        return Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue, size: 35),
            SizedBox(width: 12),
            Expanded(child: text)
          ],
        );
        break;
      case 'alert':
        return Row(
          children: [
            Icon(Icons.info_outline, color: Colors.red, size: 35),
            SizedBox(width: 12),
            Expanded(child: text)
          ],
        );
      default:
        return text;
    }
  }
}
