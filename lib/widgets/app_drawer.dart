import 'package:flutter/material.dart';
import 'package:messman/screens/auth/profile_screen.dart';
import 'package:messman/screens/deposits_screen.dart';
import 'package:messman/screens/meals/meals_screen.dart';
import 'package:messman/screens/members_screen.dart';
import 'package:messman/screens/settings/settings_screen.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/widgets/network_circle_avatar.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NetworkCircleAvatar(imageUrl: user.imageUrl),
                SizedBox(height: 12),
                if (user.name != null && user.name.isNotEmpty) ...[
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                ],
                if (user.email != null && user.email.isNotEmpty) ...[
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                ],
                GestureDetector(
                  onTap: () {
                    auth.logout();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
          drawerItem('Meals', Icons.restaurant, () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(MealsScreen.routeName);
          }),
          drawerItem('Mess Members', Icons.group, () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(MembersScreen.routeName);
          }),
          drawerItem('Deposits', Icons.monetization_on, () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(DepositsScreen.routeName);
          }),
          drawerItem('Settings', Icons.settings, () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(SettingsScreen.routeName);
          }),
          drawerItem('Profile', Icons.person, () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(ProfileScreen.routeName);
          }),
        ],
      ),
    );
  }

  Widget drawerItem(String title, icon, onTap) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: Icon(icon, size: 20),
          onTap: onTap,
        ),
        Divider(height: 0),
      ],
    );
  }
}
