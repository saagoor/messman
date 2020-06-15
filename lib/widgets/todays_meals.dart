import 'package:flutter/material.dart';
import 'package:mess/models/meal.dart';
import 'package:mess/screens/meals/set_meal_screen.dart';
import 'package:mess/services/meals_service.dart';
import 'package:provider/provider.dart';

class TodaysMeals extends StatelessWidget {
  final bool alwaysShowSetBtn;
  TodaysMeals({
    this.alwaysShowSetBtn = false,
  });

  @override
  Widget build(BuildContext context) {
    final mealsService = Provider.of<MealsService>(context);
    final mealsOfDay = mealsService.messMeals(DateTime.now());
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: mealsOfDay.values.map((item) => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MealCard(
              meal: item,
            alwaysShowSetBtn: alwaysShowSetBtn,
          ),
          SizedBox(width: 10),
          ],
        )).toList(),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;
  final bool alwaysShowSetBtn;

  const MealCard({
    Key key,
    @required this.meal,
    this.alwaysShowSetBtn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      overflow: Overflow.visible,
      // fit: StackFit.expand,
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              width: 150,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/${meal.type}.png', height: 30),
                      SizedBox(height: 8),
                      Text(meal.type.toUpperCase()),
                      SizedBox(height: 4),
                      if(alwaysShowSetBtn || meal != null)
                      Text(
                        meal ?? 'Not Set',
                        style: TextStyle(
                            color: meal != null
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).errorColor),
                      ),
                      if (alwaysShowSetBtn || meal == null || meal.food == null) ...[
                        SizedBox(height: 10),
                        SizedBox(
                          height: 25,
                          child: OutlineButton(
                            onPressed: () async {
                              int foodId =
                                  await Navigator.of(context).pushNamed(
                                SetMealScreen.routeName,
                                arguments: meal?.food?.title ?? '',
                              ) as int;
                              final DateTime dateTime =
                                  Provider.of<DateTime>(context, listen: false);
                              Provider.of<MealsService>(context,
                                      listen: false)
                                  .setMenu(dateTime, meal?.type, foodId);
                            },
                            child: Text('Set ${meal?.type ?? ''}',
                                style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColorDark)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
        Positioned(
          bottom: 0,
          child: Consumer<Meal>(
            builder: (ctx, mealAlt, child) => Row(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    icon: Icon(Icons.thumb_down),
                    onPressed: () {
                      mealAlt.dislike();
                    },
                    iconSize: 15,
                    visualDensity: VisualDensity.compact,
                    color: !mealAlt.likedByUser
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: () {
                      mealAlt.like();
                    },
                    iconSize: 15,
                    visualDensity: VisualDensity.compact,
                    color: mealAlt.likedByUser
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
