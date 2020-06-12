import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mess/services/members_service.dart';
import 'package:mess/services/mess_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final messService = Provider.of<MessService>(context);
    final membersService = Provider.of<MembersService>(context);
    final createdBy = membersService.memberById(messService.mess?.createdBy);
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 15),
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  messService.mess?.name ?? '',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 10),
                Text(messService.mess?.location ?? 'No Address'),
                SizedBox(height: 10),
                Text('${membersService.items.length} Members'),
                SizedBox(height: 10),
                Text('Joined MessMan at ' + DateFormat.yMMM().format(messService.mess?.createdAt ?? DateTime.now())),
                SizedBox(height: 10),
                Text('Created by ' + createdBy.name),
                SizedBox(height: 10),
                OutlineButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit, size: 18),
                  label: Text('Edit Mess'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(30),
                  ),
                ),
              ],
            ),
            Divider(height: 30),
            Column(
              children: <Widget>[
                Text(
                  'Current Month: ' +
                      DateFormat.yMMMM().format(
                        messService.mess?.currentMonth ?? DateTime.now(),
                      ),
                  style: TextStyle(fontSize: 16),
                ),
                Text('Close current month and start fresh.'),
                SizedBox(height: 10),
                FlatButton(
                  onPressed: () {},
                  child: Text('Close Month'),
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(30),
                  ),
                ),
              ],
            ),
            Divider(height: 30),
          ],
        ),
      ),
    );
  }
}
