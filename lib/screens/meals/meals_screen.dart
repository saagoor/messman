import 'package:flutter/material.dart';
import 'package:mess/screens/meals/add_guest_meal.dart';
import 'package:mess/screens/meals/meals_planner_view.dart';
import 'package:mess/screens/meals/meals_table_view_screen.dart';

class MealsScreen extends StatelessWidget {
  static const routeName = '/meals';

  Widget build(BuildContext context) {
    final now = DateTime.now();
    int currentIndex = (now.day - 1);

    return DefaultTabController(
      initialIndex: (now.day - 1),
      length: lastDay(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.3,
          title: Text('Meal Planner'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.grid_on, size: 20),
              onPressed: () {
                Navigator.of(context).pushNamed(MealsTableViewScreen.routeName);
              },
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 50),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: TabBar(
                indicatorPadding: EdgeInsets.only(bottom: 0, top: 10),
                indicatorWeight: 0,
                isScrollable: true,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).primaryColorLight,
                    ],
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).primaryColorLight,
                    width: 1,
                  ),
                ),
                onTap: (tappedIndex) {
                  currentIndex = tappedIndex;
                },
                tabs: List.generate(
                    lastDay(), (index) => Tab(text: '${index + 1}')).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children:
              List.generate(lastDay(), (index) => MealsPlannerView(index + 1))
                  .toList(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.exposure_plus_1),
          onPressed: () {
            final dateTime = DateTime(now.year, now.month, currentIndex + 1);
            showModalBottomSheet(
              context: context,
              builder: (ctx) => AddGuestMeal(date: dateTime),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            );
          },
        ),
      ),
    );
  }

  int lastDay() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0).day;
  }
}
