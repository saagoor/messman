import 'package:flutter/material.dart';
import 'package:messman/widgets/user/users_currency.dart';

class Amount extends StatelessWidget {
  final double amount;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showCurrency;

  Amount(
    this.amount, {
    this.fontSize,
    this.fontWeight,
    this.showCurrency = true,
  });

  @override
  Widget build(BuildContext context) {
    final String roundedAmount = (amount == null || amount == 0 || amount.isNaN)
        ? '0.0'
        : amount.toStringAsFixed(2);
    final String amountStr = roundedAmount.split('.')[0];
    final String amountFraction = amount.truncateToDouble() == amount
        ? ''
        : '.' + roundedAmount.split('.')[1];

    return FittedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (showCurrency)
            UsersCurrency(fontSize: fontSize != null ? fontSize * 0.7 : 10),
          Text(
            '$amountStr',
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: amount < 0 ? Theme.of(context).errorColor : null,
            ),
          ),
          if (amountFraction.isNotEmpty)
            Text(
              amountFraction,
              style: TextStyle(
                fontWeight: fontWeight,
                fontSize: fontSize != null ? fontSize * 0.7 : 10,
                color: amount < 0 ? Theme.of(context).errorColor : null,
              ),
            )
        ],
      ),
    );
  }
}
