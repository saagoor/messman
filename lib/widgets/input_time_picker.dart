import 'package:flutter/material.dart';

class InputTimePicker extends StatelessWidget {
  final Function onSelect;
  final TimeOfDay initialTime;

  InputTimePicker({
    @required this.onSelect,
    this.initialTime,
  });

  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: OutlineButton(
        onPressed: () {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            useRootNavigator: true,
          ).then((pickedTime) {
            if (pickedTime == null) {
              return;
            }
            onSelect(pickedTime);
            print(pickedTime);
          });
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.access_time, size: 20, color: Colors.grey),
            ),
            Text(
              initialTime == null ? 'Select Time' : initialTime.format(context),
            ),
          ],
        ),
        shape: Theme.of(context).inputDecorationTheme.border,
      ),
    );
  }
}
