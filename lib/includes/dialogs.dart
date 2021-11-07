import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/screens/close_month/close_month_screen.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';

showConfirmationDialog({
  final BuildContext context,
  final Function deleteMethod,
  final String title = 'Deletion Alert!',
  final String confirmBtnText = 'Delete',
  final String content = 'Are you sure you want to delete this item?',
  final String successMessage = 'Deleted successfully!',
}) async {
  bool confirmDelete = await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      actionsPadding: EdgeInsets.only(right: 10),
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: Text('Cancel'),
        ),
        FlatButton(
          color: Theme.of(ctx).errorColor,
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
          child: Text(confirmBtnText),
        )
      ],
    ),
  );
  if (confirmDelete != null && confirmDelete) {
    final result = await deleteMethod().then((value) {
      if (context != null && value == true) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(successMessage)),
        );
      }
      return value;
    }).catchError((error) {
      if (context != null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    });
    return result;
  }
}

void monthEndsClosingAlert(BuildContext context) {
  final currentMonth =
      Provider.of<MessService>(context, listen: false).mess?.currentMonth;
  if (currentMonth == null) return;

  if (isCurrentMonthExpiring(currentMonth)) {
    print('showing close month alert');
    Future.delayed(Duration(seconds: 0)).then((value) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${DateFormat.yMMMM().format(currentMonth)} is over!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text('Ready to close the month yet?'),
              SizedBox(height: 20),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(CloseMonthScreen.routeName);
                },
                child: Text('Close Month'),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        // backgroundColor: Theme.of(context).primaryColorLight,
      );
    });
  } else {
    print('Not showing close month');
  }
}

Future showInfoDialog({
  final BuildContext context,
  final String title = 'Info!',
  final String buttonText = 'Okay',
  final String content = '',
}) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      actionsPadding: EdgeInsets.only(right: 10),
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text(buttonText),
        )
      ],
    ),
  );
}
