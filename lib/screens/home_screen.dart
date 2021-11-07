import 'package:flutter/material.dart';
import 'package:messman/includes/dialogs.dart';
import 'package:messman/screens/meals/meals_screen.dart';
import 'package:messman/screens/tabs/expenses_tab.dart';
import 'package:messman/screens/tabs/overview_tab.dart';
import 'package:messman/screens/tabs/tasks_tab.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/services/mess_service.dart';
import 'package:messman/widgets/app_drawer.dart';
import 'package:messman/widgets/chat_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = false;
  bool _isLoading = false;
  int _currentIndex = 0;
  MessService _messService;

  void _loadMessData() async {
    _isLoading = true;
    await Provider.of<MessService>(context, listen: false)
        .fetchAndSet()
        .catchError((error) {
      showHttpError(context, error);
    });
    if (context != null) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit && !_messService.isLoaded) {
      _loadMessData();
    }
    if (mounted) monthEndsClosingAlert(context);
  }

  @override
  Widget build(BuildContext context) {
    _messService = Provider.of<MessService>(context);
    if (!_isInit && !_messService.isLoaded) {
      _loadMessData();
      _isInit = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_theTitle()),
        actions: <Widget>[
          ChatButton(),
          SizedBox(width: 8),
        ],
      ),
      drawer: AppDrawer(),
      body:
          _isLoading ? Center(child: CircularProgressIndicator()) : _theView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: 'Tasks & Bazar..',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Meals',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _tabOnTap,
      ),
    );
  }

  void _tabOnTap(index) {
    if (index == 3) {
      Navigator.of(context).pushNamed(MealsScreen.routeName).then((value) {
        setState(() {});
      });
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
        return 'Tasks & Bazar Dates';
      default:
        return _messService?.mess?.name ?? 'MessMan';
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
