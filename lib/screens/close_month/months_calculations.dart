import 'package:flutter/material.dart';
import 'package:messman/services/calc_service.dart';
import 'package:messman/widgets/boxed_item.dart';
import 'package:provider/provider.dart';

class MonthsCalculations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<CalcService>(context);

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 3 / 2.5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      physics: NeverScrollableScrollPhysics(),
      children: [
        BoxedItem(
          amount: calc.expenseTotal,
          title: 'Total Expense',
          color: Colors.lime.shade200,
        ),
        BoxedItem(
          amount: calc.shoppingExpenseTotal,
          title: 'Bazar Expense',
          color: Colors.amber.shade200,
        ),
        BoxedItem(
          amount: calc.utilityExpenseTotal,
          title: 'Utility Expense',
          color: Colors.orange.shade200,
        ),
        BoxedItem(
          amount: calc.mealsCount,
          title: 'Total Meal',
          color: Colors.lime.shade200,
          showCurrency: false,
        ),
        BoxedItem(
          amount: calc.mealRate,
          title: 'Meal Rate',
          color: Colors.amber.shade200,
        ),
        BoxedItem(
          amount: calc.utilsAvg,
          title: 'Utility Average',
          color: Colors.orange.shade200,
        ),
      ],
    );
  }
}
