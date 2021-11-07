import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';

class UsersCurrency extends StatelessWidget {
  final double fontSize;
  UsersCurrency({this.fontSize = 10});

  @override
  Widget build(BuildContext context) {
    final messService = Provider.of<MessService>(context);

    final String currencySymbol = messService.mess?.currencySymbol ??
        NumberFormat.simpleCurrency(locale: Intl.systemLocale).currencySymbol;
    return Text(
      currencySymbol,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
