import 'package:flutter/material.dart';
import 'package:mess/screens/meals/set_meal_screen.dart';
import 'package:mess/services/food_service.dart';
import 'package:provider/provider.dart';

class TodaysMeals extends StatelessWidget {
  final bool alwaysShowSetBtn;
  TodaysMeals({
    this.alwaysShowSetBtn = false,
  });

  @override
  Widget build(BuildContext context) {
    final dailyFoods = Provider.of<DailyFoodsService>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          MealCard(
            title: 'Breakfast',
            meal: dailyFoods.breakfast,
            imageName: 'breakfast.png',
            alwaysShowSetBtn: alwaysShowSetBtn,
          ),
          SizedBox(width: 10),
          MealCard(
            title: 'Lunch',
            meal: dailyFoods.lunch,
            imageName: 'lunch.png',
            alwaysShowSetBtn: alwaysShowSetBtn,
          ),
          SizedBox(width: 10),
          MealCard(
            title: 'Dinner',
            meal: dailyFoods.dinner,
            imageName: 'dinner.png',
            alwaysShowSetBtn: alwaysShowSetBtn,
          ),
        ],
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String title;
  final String meal;
  final String imageName;
  final bool alwaysShowSetBtn;

  const MealCard({
    Key key,
    @required this.title,
    @required this.meal,
    @required this.imageName,
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
                      Image.asset('assets/images/$imageName', height: 30),
                      SizedBox(height: 8),
                      Text(title),
                      SizedBox(height: 4),
                      if(alwaysShowSetBtn || meal != null)
                      Text(
                        meal ?? 'Not Set',
                        style: TextStyle(
                            color: meal != null
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).errorColor),
                      ),
                      if (alwaysShowSetBtn || meal == null || meal.isEmpty) ...[
                        SizedBox(height: 10),
                        SizedBox(
                          height: 25,
                          child: OutlineButton(
                            onPressed: () async {
                              String foodTitle =
                                  await Navigator.of(context).pushNamed(
                                SetMealScreen.routeName,
                                arguments: title,
                              ) as String;
                              final DateTime dateTime =
                                  Provider.of<DateTime>(context, listen: false);
                              Provider.of<DailyFoodsService>(context,
                                      listen: false)
                                  .setMenu(dateTime, title, foodTitle);
                            },
                            child: Text('Set $title',
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
          child: Consumer<DailyFoodsService>(
            builder: (ctx, dailyFoods, child) => Row(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    icon: Icon(Icons.thumb_down),
                    onPressed: () {
                      dailyFoods.setReact(
                          title, dailyFoods.react(title) == -1 ? 0 : -1);
                    },
                    iconSize: 15,
                    visualDensity: VisualDensity.compact,
                    color: dailyFoods.react(title) == -1
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
                      dailyFoods.setReact(
                          title, dailyFoods.react(title) == 1 ? 0 : 1);
                    },
                    iconSize: 15,
                    visualDensity: VisualDensity.compact,
                    color: dailyFoods.react(title) == 1
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
