import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mess/services/calc_service.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/services/mess_service.dart';
import 'package:mess/widgets/meal/todays_meals.dart';
import 'package:mess/widgets/mess_overview.dart';
import 'package:mess/widgets/section_title.dart';
import 'package:mess/widgets/user/personal_overview.dart';
import 'package:mess/widgets/user/users_tasks.dart';
import 'package:provider/provider.dart';

class OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messService = Provider.of<MessService>(context);
    return RefreshIndicator(
      onRefresh: () async {
        await messService.fetchAndSet().catchError((error) {
          showHttpError(context, error);
        });
      },
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16),
            child: SectionTitle(
                icon: Icons.restaurant,
                title: 'Today\'s Meals - ' +
                    DateFormat.MMMMEEEEd().format(DateTime.now())),
          ),
          SizedBox(height: 8),
          Provider<DateTime>.value(
            value: DateTime.now(),
            child: TodaysMeals(),
          ),
          Divider(
            height: 35,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SectionTitle(icon: Icons.toc, title: 'Upcoming Tasks'),
                SizedBox(height: 8),
                UsersTasks(),
                SizedBox(height: 20),
                SectionTitle(
                  icon: Icons.person_outline,
                  title: 'Personal Overview',
                ),
                SizedBox(height: 8),
                ChangeNotifierProvider.value(
                  value: CalcService(context),
                  child: PersonalOverview(),
                ),
                SizedBox(height: 20),
                SectionTitle(
                  icon: Icons.timeline,
                  title:
                      'Mess\'s Overview  - ${DateFormat.yMMMM().format(DateTime.now())}',
                ),
                SizedBox(height: 8),
                ChangeNotifierProvider.value(
                  value: CalcService(context),
                  child: MessOverview(),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
