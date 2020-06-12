import 'package:flutter/material.dart';
import 'package:mess/models/models.dart';
import 'package:mess/services/auth_service.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatelessWidget {
  final User user;

  const ProfileCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Hero(
          tag: user.id ?? 0,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: user?.imageUrl != null
                ? NetworkImage(user.imageUrl)
                : AssetImage('assets/images/user-placeholder.png'),
          ),
        ),
        SizedBox(height: 20),
        Text(
          user?.name ?? 'MessMan Member',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 5),
        Text(user?.email ?? ''),
        if (user?.id ==
            Provider.of<AuthService>(context, listen: false).user?.id) ...[
          SizedBox(height: 15),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadiusDirectional.circular(30),
            ),
            child: FlatButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit),
              label: Text('Edit Profile'),
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(30),
              ),
            ),
          ),
        ],
        SizedBox(height: 10),
      ],
    );
  }
}
