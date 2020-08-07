import 'package:flutter/material.dart';
import 'package:mess/models/models.dart';
import 'package:mess/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCard extends StatelessWidget {
  final User user;

  const ProfileCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
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
        SizedBox(height: 15),
        if (user?.id == auth.user?.id) ...[
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
        if (user?.id != auth.user?.id) ...[
          Row(
            children: <Widget>[
              RaisedButton(
                color: Colors.white,
                child: Icon(Icons.call),
                onPressed: () {
                  _launchPhone().catchError((error) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(error.toString()),
                    ));
                  });
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(25),
                visualDensity: VisualDensity.compact,
              ),
              RaisedButton(
                color: Colors.white,
                child: Icon(Icons.email),
                onPressed: () {
                  _launchEmail().catchError((error) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(error.toString()),
                    ));
                  });
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(25),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
        SizedBox(height: 10),
      ],
    );
  }

  Future<void> _launchPhone() async {
    if(user?.phone == null || user.phone.isEmpty){
      throw 'User did not add a phone number!';
    }
    final url = 'tel:${user.phone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not call the user!';
    }
  }

  Future<void> _launchEmail() async {
    final url = 'mailto:${user.email}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not email the user!';
    }
  }
}
