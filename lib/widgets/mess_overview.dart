import 'package:flutter/material.dart';
import 'package:mess/services/calc_service.dart';
import 'package:mess/widgets/amount.dart';
import 'package:provider/provider.dart';

class MessOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalcService>(context);

    return Column(
      children: <Widget>[
        MyListItem(
          Icons.add_circle_outline,
          'Total Deposit',
          Amount(calc.depositTotal),
        ),
        MyListItem(
          Icons.add_circle_outline,
          'Total Expense',
          Amount(calc.expenseTotal),
        ),
        MyListItem(
          Icons.attach_money,
          'Total Available Balance',
          Amount(calc.balance),
        ),
        MyListItem(
          Icons.fastfood,
          'Total Meal',
          Text(calc.mealsCount.toString()),
        ),
        MyListItem(
          Icons.restaurant,
          'Current Meal Rate',
          Amount(calc.mealRate),
        ),
        MyListItem(
          Icons.toys,
          'Avarage Utility Costs',
          Amount(calc.utilsAvg),
        ),
      ],
    );
  }
}

class MyListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  MyListItem(this.icon, this.title, this.trailing);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: Colors.grey, size: 20),
          SizedBox(width: 20),
          Expanded(child: Text(title)),
          trailing,
        ],
      ),
    );
  }
}
