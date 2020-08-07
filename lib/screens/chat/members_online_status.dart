import 'package:flutter/material.dart';
import 'package:mess/services/members_service.dart';
import 'package:mess/widgets/user/members_circle_avatar.dart';
import 'package:provider/provider.dart';

class MembersOnlineStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final member = Provider.of<MembersService>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: member.items.map((e) {
          return Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  MembersCircleAvatar(
                    imageUrl: e.imageUrl,
                    firstChar: e.name[0],
                    radius: 20,
                  ),
                  Positioned(
                    right: 10,
                    bottom: 5,
                    child: Container(
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Text(e.name ?? '', style: Theme.of(context).textTheme.bodyText1,),
                ],
              ),
              SizedBox(width: 2),
            ],
          );
        }).toList(),
      ),
    );
  }
}
