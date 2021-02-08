import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/models/expense.dart';
import 'package:messman/models/transaction.dart';
import 'package:messman/models/user.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/widgets/amount.dart';
import 'package:messman/widgets/list_view_empty.dart';
import 'package:provider/provider.dart';

class DepositsListView extends StatelessWidget {
  final List<Transaction> deposits;
  final double reduceSize;
  DepositsListView(this.deposits, {this.reduceSize = 0});

  @override
  Widget build(BuildContext context) {
    if (deposits.length <= 0) {
      return ListViewEmpty(text: 'No deposits found!', reduceSize: reduceSize);
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      itemCount: deposits.length,
      itemBuilder: (ctx, i) => Column(
        children: <Widget>[
          DepositsListCard(deposits[i]),
          SizedBox(height: 6),
        ],
      ),
    );
  }
}

class DepositsListCard extends StatelessWidget {
  final Transaction deposit;
  const DepositsListCard(this.deposit);

  @override
  Widget build(BuildContext context) {
    final User member = Provider.of<MembersService>(context, listen: false)
        .memberById(deposit.memberId);
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 10),
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child:
                Amount(deposit.amount.toDouble(), fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(member.name ?? 'MessMan User'),
            Text(
              deposit is Expense ? 'From Expense' : 'Deposited to Manager',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ],
        ),
        subtitle: Text(DateFormat.MMMMEEEEd().format(deposit.dateTime)),
        trailing: PopupMenuButton<DepositActions>(
          itemBuilder: (ctx) => [
            PopupMenuItem(
              child:
                  Text('Edit ' + (deposit is Expense ? 'Expense' : 'Deposit')),
              value: DepositActions.Edit,
            ),
            PopupMenuItem(
              child: Text(
                  'Delete ' + (deposit is Expense ? 'Expense' : 'Deposit')),
              value: DepositActions.Delete,
            ),
          ],
          onSelected: (selected) {
            if (selected == DepositActions.Edit) {
              deposit.edit(context);
            }
            if (selected == DepositActions.Delete) {
              deposit.delete(context);
            }
          },
        ),
      ),
    );
  }
}

enum DepositActions {
  Edit,
  Delete,
}
