import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  SectionTitle({
    @required this.icon,
    @required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.grey.shade700),
        SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}