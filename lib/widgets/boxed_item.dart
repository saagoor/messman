import 'package:flutter/material.dart';
import 'package:messman/widgets/amount.dart';

class BoxedItem extends StatelessWidget {
  final double amount;
  final String title;
  final Color color;
  final bool showCurrency;

  BoxedItem({
    @required this.amount,
    @required this.title,
    this.color,
    this.showCurrency = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: color ?? Theme.of(context).primaryColor.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Amount(
              amount,
              fontSize: Theme.of(context).textTheme.headline2.fontSize * 1.3,
              fontWeight: FontWeight.bold,
              showCurrency: showCurrency,
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline3.fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
