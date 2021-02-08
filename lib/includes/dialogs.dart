import 'package:flutter/material.dart';

void showDeleteDialog({
  BuildContext context,
  Function deleteMethod,
  String title = 'Deletion Alert!',
  String content = 'Are you sure you want to delete this item?',
  String successMessage = 'Deleted successfully!',
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
          child: Text('Delete'),
        )
      ],
    ),
  );
  if (confirmDelete != null && confirmDelete) {
    deleteMethod().then((value) {
      if (context != null && value == true) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(successMessage)),
        );
      }
    }).catchError((error) {
      if (context != null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    });
  }
}
