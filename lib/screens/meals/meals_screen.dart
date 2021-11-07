import 'package:flutter/material.dart';
import 'package:messman/includes/dialogs.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/screens/meals/meals_planner_view.dart';
import 'package:messman/screens/meals/meals_table_view_screen.dart';
import 'package:messman/services/meals_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';

class MealsScreen extends StatelessWidget {
  static const routeName = '/meals';

  Widget build(BuildContext context) {
    monthEndsClosingAlert(context);
    final currentMonth = Provider.of<MessService>(
          context,
          listen: false,
        ).mess?.currentMonth ??
        DateTime.now();
    final now = DateTime.now();
    final int lastDay = lastDayOfMonth(currentMonth);
    int currentIndex =
        (currentMonth.year == now.year && currentMonth.month == now.month)
            ? (now.day - 1)
            : lastDay - 1;

    Provider.of<MealsService>(context, listen: false)
        .fetchAndSetMeals()
        .catchError((error) => showHttpError(context, error));

    return DefaultTabController(
      initialIndex: currentIndex,
      length: lastDay,
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
                tabs:
                    List.generate(lastDay, (index) => Tab(text: '${index + 1}'))
                        .toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children:
              List.generate(lastDay, (index) => MealsPlannerView(index + 1))
                  .toList(),
        ),
      ),
    );
  }
}
