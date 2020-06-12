import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mess/widgets/users_currency.dart';

class Amount extends StatelessWidget {
  final double amount;
  final double fontSize;
  final FontWeight fontWeight;

  Amount(this.amount, {this.fontSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    final amountStr =
        (amount == null || amount == 0 || amount.isNaN) ? '0' : amount.floor();
    return FittedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UsersCurrency(),
          Text(
            '$amountStr',
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: amount < 0 ? Theme.of(context).errorColor : null,
            ),
          ),
          if (amount.truncateToDouble() != amount)
            Text(
              '.${((amount % 1) * pow(10, 2)).round()}',
              style: TextStyle(
                fontWeight: fontWeight,
                fontSize: fontSize != null ? fontSize - 4 : 10,
                color: amount < 0 ? Theme.of(context).errorColor : null,
              ),
            )
        ],
      ),
    );
  }
}
