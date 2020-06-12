import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDatePicker extends StatelessWidget {
  final DateTime value;
  final Function onSelect;
  final DateTime firstDate;
  final DateTime lastDate;

  InputDatePicker({
    @required this.value,
    @required this.onSelect,
    this.firstDate,
    this.lastDate,
  });

  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: OutlineButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(now.year - 1),
            lastDate: lastDate ?? DateTime(now.year + 1),
          ).then((pickedDate) {
            if (pickedDate == null) {
              return;
            }
            onSelect(pickedDate);
          });
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.insert_invitation, size: 20, color: Colors.grey),
            ),
            Text(
              value == null
                  ? 'Select Date'
                  : DateFormat.yMMMMEEEEd().format(value),
            ),
          ],
        ),
        shape: Theme.of(context).inputDecorationTheme.border,
      ),
    );
  }
}
