import 'package:flutter/material.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';

class LeaveMessButton extends StatefulWidget {
  const LeaveMessButton({
    Key key,
  }) : super(key: key);

  @override
  _LeaveMessButtonState createState() => _LeaveMessButtonState();
}

class _LeaveMessButtonState extends State<LeaveMessButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: FlatButton.icon(
        icon: Icon(Icons.logout),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Leaving Mess'),
              content: Text('Are you sure you want to leave this mess?'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text('Cancel'),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text('Leave Mess'),
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ).then((value) async {
            if (value != null && value) {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<MessService>(
                context,
                listen: false,
              ).leaveMess().then((value) {
                if (value) {
                  return Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                }
              }).catchError((error) {
                showHttpError(context, error);
              });
              setState(() {
                _isLoading = false;
              });
            }
          });
        },
        label: _isLoading
            ? SizedBox(
                child: CircularProgressIndicator(strokeWidth: 3),
                width: 25,
                height: 25,
              )
            : Text('Leave Mess'),
        color: Theme.of(context).colorScheme.surface,
        // shape: Theme.of(context).cardTheme.shape,
        padding: const EdgeInsets.all(10),
        minWidth: double.infinity,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
