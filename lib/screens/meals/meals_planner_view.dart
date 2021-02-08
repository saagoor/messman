import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/services/meals_service.dart';
import 'package:messman/widgets/meal/meal_controller_table.dart';
import 'package:messman/widgets/meal/todays_meals.dart';
import 'package:messman/widgets/section_title.dart';
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
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: SectionTitle(
              icon: Icons.insert_invitation,
              title: DateFormat.yMMMMEEEEd().format(dateTime),
            ),
          ),
          Provider<DateTime>.value(
            value: dateTime,
            child: TodaysMeals(alwaysShowSetBtn: true, dateTime: dateTime),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionTitle(
                  icon: Icons.check_circle_outline,
                  title: 'Meal Controller',
                ),
                // SizedBox(height: 10),
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
