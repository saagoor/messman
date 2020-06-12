import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mess/models/models.dart';
import 'package:mess/services/expenses_service.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/services/members_service.dart';
import 'package:mess/widgets/amount.dart';
import 'package:provider/provider.dart';


class ExpensesListView extends StatelessWidget {
  final List<Expense> expenses;
  final double noItemHeight;
  ExpensesListView(this.expenses, {this.noItemHeight});

  @override
  Widget build(BuildContext context) {
    if (expenses.length <= 0) {
      return SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.expand(
            height: noItemHeight ?? MediaQuery.of(context).size.height - kBottomNavigationBarHeight - 50,
          ),
          child: Center(
            child: Text('No expense found!'),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemCount: expenses.length,
      itemBuilder: (ctx, i) {
        Widget append = SizedBox();
        if (i == 0) {
          append = Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 5, top: 5),
            child: Text(getWeek(expenses[i].dateTime.day)),
          );
        } else {
          if (weekNumber(expenses[i].dateTime) !=
              weekNumber(expenses[i - 1].dateTime)) {
            append = Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5, top: 5),
              child: Text(getWeek(expenses[i].dateTime.day)),
            );
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            append,
            ExpenseListItem(expenses[i]),
          ],
        );
      },
    );
  }
}

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  ExpenseListItem(this.expense);

  @override
  Widget build(BuildContext context) {
    final User expender = Provider.of<MembersService>(context).memberById(expense.expenderId);
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Amount(
                  expense.amount.toDouble(),
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (expense.shortDetails != null)
                    Text(expense.shortDetails, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text(expender?.name ?? 'MessMan User',
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  expense.type?.capitalize() ?? 'Shopping',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: 4),
                Text(
                  expense.dateTime != null
                      ? DateFormat.MMMEd().format(expense.dateTime)
                      : 'No Date',
                ),
              ],
            )
          ],
        ),
      ),
      onLongPress: () async {
        bool confirmDelete = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            actionsPadding: EdgeInsets.only(right: 10),
            title: Text('Delete Expense!'),
            content: Text('Do you want to delete this expense?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                color: Theme.of(context).errorColor,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Delete'),
              )
            ],
          ),
        );
        if (confirmDelete) {
          Provider.of<ExpensesService>(context, listen: false)
              .delete(expense.id)
              .then((value) {
            if (context != null && value == true) {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Expense deleted successfully!')),
              );
            }
          }).catchError((error) {
            if (context != null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            }
          });
        }
      },
    );
  }
}
