import 'package:flutter/material.dart';
import 'package:messman/screens/mess/create_mess_screen.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';

class MessControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messService = Provider.of<MessService>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlineButton.icon(
          onPressed: () async {
            final isUpdated = await Navigator.of(context).pushNamed(
              CreateMessScreen.routeName,
              arguments: messService.mess,
            );
            if (isUpdated != null && isUpdated && context != null) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Your mess has been updated.'),
              ));
            }
          },
          icon: Icon(Icons.edit, size: 18),
          label: Text('Edit Mess'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(30),
          ),
        ),
        SizedBox(width: 10),
        OutlineButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text(
                    'Are you sure you want to delete your mess? \nOnce you delete the mess all of it\'s associated data will be lost permanently.'),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  ),
                  FlatButton(
                    color: Theme.of(context).errorColor,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Delete'),
                  ),
                ],
              ),
            ).then((value) {
              if (value != null && value) {
                messService.deleteMess(messService.mess?.id).then((value) {
                  final auth = Provider.of<AuthService>(context, listen: false);
                  auth.user.id = null;
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                }).catchError((error) {
                  showHttpError(context, error);
                });
              }
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
    );
  }
}
