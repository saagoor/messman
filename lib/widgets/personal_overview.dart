import 'package:flutter/material.dart';
import 'package:mess/services/calc_service.dart';
import 'package:mess/widgets/amount.dart';
import 'package:provider/provider.dart';

class PersonalOverview extends StatelessWidget {
  const PersonalOverview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalcService>(context);

    return Wrap(
      spacing: 15,
      alignment: WrapAlignment.spaceBetween,
      children: <Widget>[
        OverviewCircle(
          title: 'Deposit',
          amount: calc.depositTotalOfUser,
        ),
        OverviewCircle(
          title: 'Total Meal',
          amount: calc.mealsCountOfUser,
          notCurrency: true,
        ),
        OverviewCircle(
          title: 'Expense',
          amount: calc.expenseTotalOfUser, // mealsCost + utilsCost = expense
        ),
        OverviewCircle(
          title: 'Balance',
          amount:
              calc.balanceOfUser, // deposit - mealsCost - utilsCost = balance
        ),
      ],
    );
  }
}

class OverviewCircle extends StatelessWidget {
  final String title;
  final double amount;
  final bool notCurrency;

  OverviewCircle({
    @required this.title,
    @required this.amount,
    this.notCurrency = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (notCurrency)
            Text(
              amount.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          if (!notCurrency)
            Amount(
              amount,
              fontWeight: FontWeight.bold,
            ),
          SizedBox(height: 2),
          FittedBox(child: Text(title, style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
