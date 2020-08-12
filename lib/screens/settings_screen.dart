import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/services/mess_service.dart';
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Your Mess Info',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Name: ${messService.mess?.name}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Join code: ${messService.mess?.joinCode}'),
                  SizedBox(height: 10),
                  Text(
                      'Location: ${messService.mess?.location ?? 'no address'}'),
                  SizedBox(height: 10),
                  Text('Total Member: ${membersService.items.length} members'),
                  SizedBox(height: 10),
                  Text('Created at: ' +
                      DateFormat.yMMMEd().format(
                          messService.mess?.createdAt ?? DateTime.now())),
                  SizedBox(height: 10),
                  Text('Created by: ' + createdBy.name),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      OutlineButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.edit, size: 18),
                        label: Text('Edit Mess'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(30),
                        ),
                      ),
                      SizedBox(width: 10),
                      OutlineButton.icon(
                        onPressed: () {
                          messService
                              .deleteMess(messService.mess.id)
                              .then((value) {
                            return Navigator.of(context)
                                .pushReplacementNamed('/');
                          }).catchError((error) {
                            return handleHttpErrors(error);
                          });
                        },
                        icon: Icon(Icons.delete, size: 18),
                        label: Text('Delete Mess'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(30),
                        ),
                        textColor: Theme.of(context).errorColor,
                      ),
                    ],
                  )
                ],
              ),
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
