import 'package:flutter/material.dart';

class ListViewEmpty extends StatelessWidget {
  final String text;
  final double reduceSize;
  const ListViewEmpty({
    Key key,
    this.text,
    this.reduceSize = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height:
            MediaQuery.of(context).size.height - kToolbarHeight - reduceSize,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(text ?? 'No item found!'),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
