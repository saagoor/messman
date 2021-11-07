import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/screens/close_month/close_month_screen.dart';
import 'package:messman/screens/settings/leave_mess_button.dart';
import 'package:messman/screens/settings/mess_controls.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final messService = Provider.of<MessService>(context);
    final membersService = Provider.of<MembersService>(context, listen: false);
    final createdBy = membersService.memberById(messService.mess?.createdBy);
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        messService.mess?.name ?? '',
                        style: Theme.of(context).textTheme.headline1,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                          'Location: ${messService.mess?.location ?? 'no address'}'),
                      SizedBox(height: 10),
                      Text(
                          'Total Member: ${membersService.items.length} members'),
                      SizedBox(height: 10),
                      Text('Created at: ' +
                          DateFormat.yMMMEd().format(
                              messService.mess?.createdAt ?? DateTime.now())),
                      SizedBox(height: 10),
                      Text('Created by: ' + createdBy.name),
                      SizedBox(height: 10),
                      if (auth.user != null && auth.user.isManager)
                        MessControls(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Card(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text('Join Code'),
                      Text(
                        messService.mess?.joinCode ?? '',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (auth.user != null && auth.user.isManager)
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Current Month: ' +
                              DateFormat.yMMMM().format(
                                messService.mess?.currentMonth ??
                                    DateTime.now(),
                              ),
                          style: TextStyle(fontSize: 16),
                        ),
                        Text('Close current month and start fresh.'),
                        SizedBox(height: 10),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CloseMonthScreen.routeName);
                          },
                          child: Text('Close Month'),
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.circular(30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10),
              LeaveMessButton(),
            ],
          ),
        ],
      ),
    );
  }
}
