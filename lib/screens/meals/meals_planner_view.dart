import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mess/screens/meals/add_guest_meal.dart';
import 'package:mess/screens/meals/set_meal_screen.dart';
import 'package:mess/services/food_service.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/services/meals_service.dart';
import 'package:mess/widgets/meal_controller_table.dart';
import 'package:mess/widgets/no_scaffold_fab.dart';
import 'package:mess/widgets/section_title.dart';
import 'package:mess/widgets/todays_meals.dart';
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
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                child: SectionTitle(
                    icon: Icons.insert_invitation,
                    title: DateFormat.yMMMMEEEEd().format(dateTime)),
              ),
              Provider<DateTime>.value(
                value: dateTime,
                child: TodaysMeals(alwaysShowSetBtn: true),
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
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
          NoScaffoldFAB(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => AddGuestMeal(date: dateTime),
              );
            },
            child: Icon(Icons.playlist_add),
          ),
        ],
      ),
    );
  }
}

class MealsItemCard extends StatelessWidget {
  final String title;
  final String food;

  const MealsItemCard({
    Key key,
    @required this.title,
    this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              food ?? 'Not Set',
              style: TextStyle(
                color: food != null
                    ? Theme.of(context).accentColor
                    : Theme.of(context).errorColor,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 30,
              child: OutlineButton(
                onPressed: () async {
                  String foodTitle = await Navigator.of(context).pushNamed(
                    SetMealScreen.routeName,
                    arguments: title,
                  ) as String;
                  final DateTime dateTime =
                      Provider.of<DateTime>(context, listen: false);
                  Provider.of<DailyFoodsService>(context, listen: false)
                      .setMenu(dateTime, title, foodTitle);
                },
                child: Text('Set $title', style: TextStyle(fontSize: 12)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
