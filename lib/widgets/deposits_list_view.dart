import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mess/models/models.dart';
import 'package:mess/services/members_service.dart';
import 'package:mess/widgets/amount.dart';
import 'package:mess/widgets/list_view_empty.dart';
import 'package:provider/provider.dart';

class DepositsListView extends StatelessWidget {
  final List<Deposit> deposits;
  DepositsListView(this.deposits);

  @override
  Widget build(BuildContext context) {
    if (deposits.length <= 0) {
      return ListViewEmpty(text: 'No deposits found!');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
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
  final Deposit deposit;
  const DepositsListCard(this.deposit);

  @override
  Widget build(BuildContext context) {
    final User member =
        Provider.of<MembersService>(context).memberById(deposit.memberId);
    return Card(
      child: Dismissible(
        key: Key('${deposit.id ?? 0}'),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Amount(
                deposit.amount.toDouble(),
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          title: Text(member.name ?? 'MessMan User'),
          subtitle: Text(DateFormat.MMMMEEEEd().format(deposit.dateTime)),
        ),
      ),
    );
  }
}
