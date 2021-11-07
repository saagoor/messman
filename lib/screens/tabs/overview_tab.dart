import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/screens/all_members_details_screen.dart';
import 'package:messman/services/calc_service.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/services/mess_service.dart';
import 'package:messman/widgets/meal/todays_meals.dart';
import 'package:messman/widgets/mess_overview.dart';
import 'package:messman/widgets/section_title.dart';
import 'package:messman/widgets/user/personal_overview.dart';
import 'package:messman/widgets/user/users_tasks.dart';
import 'package:provider/provider.dart';

class OverviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messService = Provider.of<MessService>(context);
    final currentMonth = messService.mess?.currentMonth ?? DateTime.now();
    return RefreshIndicator(
      onRefresh: () async {
        await messService.fetchAndSet().catchError((error) {
          showHttpError(context, error);
        });
      },
      child: ListView(
        children: <Widget>[
          if (isCurrentMonthExpired(currentMonth))
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Card(
                color: Theme.of(context).errorColor,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Current month has ended! You should close this month and start new.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 16),
              child: SectionTitle(
                icon: Icons.restaurant,
                title: 'Today\'s Meals - ' +
                    DateFormat.MMMMEEEEd().format(DateTime.now()),
              ),
            ),
            SizedBox(height: 8),
            Provider<DateTime>.value(
              value: DateTime.now(),
              child: ChangeNotifierProvider.value(
                value: CalcService(context),
                child: TodaysMeals(),
              ),
            ),
            Divider(height: 20),
          ],
          Divider(height: 35),
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
                      'Mess\'s Overview  - ${DateFormat.yMMMM().format(currentMonth)}',
                ),
                SizedBox(height: 8),
                ChangeNotifierProvider.value(
                  value: CalcService(context),
                  child: MessOverview(),
                ),
                SizedBox(height: 20),
                Center(
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AllMembersDetailsScreen.routeName);
                    },
                    child: Text('View All Members Details'),
                    color: Theme.of(context).primaryColor,
                  ),
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
