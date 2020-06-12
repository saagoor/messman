import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mess/screens/close_month_screen.dart';
import 'package:mess/screens/meals/meals_screen.dart';
import 'package:mess/screens/tabs/expenses_tab.dart';
import 'package:mess/screens/tabs/overview_tab.dart';
import 'package:mess/screens/tabs/tasks_tab.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/services/mess_service.dart';
import 'package:mess/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = false;
  int _currentIndex = 0;

  void _onAppStart() {
    if (0 != 1) return;
    final currentMonth =
        Provider.of<MessService>(context, listen: false).mess?.currentMonth;
    if (context != null &&
        currentMonth != null &&
        currentMonth.month < DateTime.now().month) {
      Future.delayed(Duration(seconds: 0)).then((value) {
        showModalBottomSheet(
          context: context,
          builder: (ctx) => Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${DateFormat.yMMMM().format(currentMonth)} is over!',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text('Ready to close the month yet?'),
                SizedBox(height: 20),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(CloseMonthScreen.routeName);
                  },
                  child: Text('Close Month'),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          // backgroundColor: Theme.of(context).primaryColorLight,
        );
      });
    }
  }

  void _loadMessData() {
    final messService = Provider.of<MessService>(context);
    if (!messService.isLoaded) {
      messService.fetchAndSet().catchError((error) {
        showHttpError(context, error);
      });
    }
  }

  @override
  void initState() {
    if (mounted) _onAppStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      _loadMessData();
      _isInit = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_theTitle()),
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              'assets/images/chat.png',
            ),
            onPressed: () {},
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _theView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Overview'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text('Expenses'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            title: Text('Tasks'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            title: Text('Meals'),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _tabOnTap,
      ),
    );
  }

  void _tabOnTap(index) {
    if (index == 3) {
      Navigator.of(context).pushNamed(MealsScreen.routeName);
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  String _theTitle() {
    switch (_currentIndex) {
      case 1:
        return 'Mess Expenses';
      case 2:
        return 'Tasks';
      default:
        return Provider.of<MessService>(context, listen: false).mess?.name ??
            'MessMan';
    }
  }

  Widget _theView() {
    switch (_currentIndex) {
      case 0:
        return OverviewTab();
      case 1:
        return ExpensesTab();
      case 2:
        return TasksTab();
      default:
        return OverviewTab();
    }
  }
}
