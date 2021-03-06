import 'package:flutter/material.dart';
import 'package:messman/screens/save_expense_screen.dart';
import 'package:messman/services/expenses_service.dart';
import 'package:messman/widgets/expenses_list_view.dart';
import 'package:messman/widgets/no_scaffold_fab.dart';
import 'package:provider/provider.dart';
import '../../includes/helpers.dart';

class ExpensesTab extends StatefulWidget {
  @override
  _ExpensesTabState createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  ExpensesService expensesService;

  Future<void> _loadExpenses() async {
    return expensesService.fetchAndSet().catchError((error) {
      showHttpError(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    expensesService = Provider.of<ExpensesService>(context);

    return Stack(
      children: <Widget>[
        Container(
          constraints: BoxConstraints.expand(),
          child: RefreshIndicator(
            onRefresh: _loadExpenses,
            child: ExpensesListView(expensesService.items),
          ),
        ),
        NoScaffoldFAB(
          onPressed: () async {
            final hasSaved = await Navigator.of(context)
                .pushNamed(SaveExpenseScreen.routeName);
            if (hasSaved == true) {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Expense added successfully!')),
              );
            }
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}
