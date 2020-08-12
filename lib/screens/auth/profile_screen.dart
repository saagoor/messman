import 'package:flutter/material.dart';
import 'package:messman/models/models.dart';
import 'package:messman/screens/tabs/tasks_tab.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/deposits_service.dart';
import 'package:messman/services/expenses_service.dart';
import 'package:messman/services/tasks_service.dart';
import 'package:messman/widgets/deposits_list_view.dart';
import 'package:messman/widgets/expenses_list_view.dart';
import 'package:messman/widgets/user/profile_card.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final expense = Provider.of<ExpensesService>(context);
    final deposit = Provider.of<DepositsService>(context);
    final task = Provider.of<TasksService>(context);

    User user = ModalRoute.of(context).settings.arguments as User;
    if (user == null) {
      user = auth.user;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          // physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (ctx, innerBoxIsScrolled) => <Widget>[
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                user: user,
                tabBar: TabBar(
                  tabs: [
                    Tab(text: 'Deposits'),
                    Tab(text: 'Expenses'),
                    Tab(text: 'Tasks'),
                  ],
                ),
              ),
              // delegate: MyDelegate(),
              pinned: true,
            ),
          ],
          body: TabBarView(
            children: [
              DepositsListView(deposit.depositsByUser(user?.id),
                  reduceSize: 300),
              ExpensesListView(expense.expensesByUser(user?.id),
                  reduceSize: 300),
              TasksListView(task.usersTasks(userId: user?.id), reduceSize: 300),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({this.tabBar, this.user});

  final TabBar tabBar;
  final User user;

  @override
  double get minExtent => tabBar.preferredSize.height + kToolbarHeight + 25;
  @override
  double get maxExtent => tabBar.preferredSize.height + 300;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // final resizedHeight = (300 - shrinkOffset);

    double resizedOpacity = 1 - shrinkOffset / (300);
    if (resizedOpacity > 1) {
      resizedOpacity = 1;
    } else if (resizedOpacity < 0) {
      resizedOpacity = 0;
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        child: Column(
          children: <Widget>[
            AppBar(
              elevation: (shrinkOffset / maxExtent) / 5,
              backgroundColor: Colors.white,
              title: Opacity(
                opacity: shrinkOffset / maxExtent,
                child: Text(user?.name ?? 'MessMan User'),
              ),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Opacity(
                  opacity: resizedOpacity,
                  child: ProfileCard(user: user),
                ),
              ),
            ),
            tabBar,
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
