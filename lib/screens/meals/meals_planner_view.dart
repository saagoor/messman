import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/services/meals_service.dart';
import 'package:mess/widgets/meal/meal_controller_table.dart';
import 'package:mess/widgets/meal/todays_meals.dart';
import 'package:mess/widgets/section_title.dart';
import 'package:provider/provider.dart';

class MealsPlannerView extends StatelessWidget {
  final int dayOfMonth;
  MealsPlannerView(this.dayOfMonth);
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime(now.year, now.month, dayOfMonth);

    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<MealsService>(context, listen: false)
            .fetchAndSetMeals()
            .catchError((error) => showHttpError(context, error));
      },
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: SectionTitle(
              icon: Icons.insert_invitation,
              title: DateFormat.yMMMMEEEEd().format(dateTime),
            ),
          ),
          Provider<DateTime>.value(
            value: dateTime,
            child: TodaysMeals(alwaysShowSetBtn: true, dateTime: dateTime),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.check_circle_outline),
                    SizedBox(width: 8),
                    Text('Meal Controller'),
                  ],
                ),
                SizedBox(height: 20),
                MealControllerTable(dateTime),
                SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
