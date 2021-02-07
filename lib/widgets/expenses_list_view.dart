import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/models/expense.dart';
import 'package:messman/models/transaction.dart';
import 'package:messman/models/user.dart';
import 'package:messman/services/expenses_service.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/widgets/amount.dart';
import 'package:messman/widgets/list_view_empty.dart';
import 'package:provider/provider.dart';

class ExpensesListView extends StatelessWidget {
  final List<Expense> expenses;
  final double reduceSize;
  ExpensesListView(this.expenses, {this.reduceSize = 0});

  @override
  Widget build(BuildContext context) {
    if (expenses.length <= 0) {
      return ListViewEmpty(
        text: 'No expense found!',
        reduceSize: reduceSize,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
    final User expender =
        Provider.of<MembersService>(context).memberById(expense.memberId);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Amount(expense.amount.toDouble(),
                    fontWeight: FontWeight.bold),
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
                  Row(
                    children: [
                      Text(expender?.name ?? 'MessMan User',
                          style: TextStyle(fontSize: 13)),
                      SizedBox(width: 5),
                      Text(
                        expense.fromSelfPocket ? 'Self Pocket' : 'Mess Balance',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
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
            ),
            PopupMenuButton(
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  child: Text('Edit Expense'),
                  value: ExpenseActions.Edit,
                ),
                PopupMenuItem(
                  child: Text('Delete Expense'),
                  value: ExpenseActions.Delete,
                ),
              ],
              onSelected: (selectedItem) async {
                if (selectedItem == ExpenseActions.Edit) {
                } else if (selectedItem == ExpenseActions.Delete) {
                  expense.delete(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

enum ExpenseActions { Edit, Delete }
