import 'package:flutter/material.dart';
import 'package:messman/screens/meals/meal_card.dart';
import 'package:messman/services/meals_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';

class TodaysMeals extends StatelessWidget {
  final DateTime dateTime;
  final bool alwaysShowSetBtn;
  TodaysMeals({
    this.dateTime,
    this.alwaysShowSetBtn = false,
  });

  @override
  Widget build(BuildContext context) {
    final mealsService = Provider.of<MealsService>(context);
    final messService = Provider.of<MessService>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          if (messService.mess != null &&
              messService.mess.breakfastSize > 0) ...[
            MealCard(
              meal: mealsService.breakfast(dateTime),
              alwaysShowSetBtn: alwaysShowSetBtn,
            ),
            SizedBox(width: 10),
          ],
          MealCard(
            meal: mealsService.lunch(dateTime),
            alwaysShowSetBtn: alwaysShowSetBtn,
          ),
          SizedBox(width: 10),
          MealCard(
            meal: mealsService.dinner(dateTime),
            alwaysShowSetBtn: alwaysShowSetBtn,
          ),
        ],
      ),
    );
  }
}
