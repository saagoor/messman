import 'package:flutter/material.dart';
import 'package:messman/models/user.dart';
import 'package:messman/services/calc_service.dart';
import 'package:messman/services/members_service.dart';
import 'package:provider/provider.dart';

class MembersDataOfMonth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final membersService = Provider.of<MembersService>(context);
    final calcService = Provider.of<CalcService>(context);

    return Table(
      border: TableBorder.all(width: 1, color: Colors.grey.shade200),
      columnWidths: {
        1: FractionColumnWidth(1.5 / 12),
        2: FractionColumnWidth(2 / 12),
        3: FractionColumnWidth(1.8 / 12),
        4: FractionColumnWidth(2.8 / 12),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            td(Text('Member Name')),
            Text('Meal'),
            Text('Expense'),
            Text('Deposit'),
            Row(
              children: [
                Text('Debit', style: TextStyle(color: Colors.green)),
                Text('/'),
                Text('Credit', style: TextStyle(color: Colors.red)),
              ],
            ),
          ],
        ),
        ...membersService.items
            .map((member) => membersRow(member, calcService))
            .toList(),
      ],
    );
  }

  TableRow membersRow(User member, CalcService calc) {
    return TableRow(
      children: [
        td(Text(member.name)),
        Text(calc.mealsCountOfUser(member.id).toStringAsFixed(1)),
        Text(calc.expenseTotalOfUser(member.id).toStringAsFixed(2)),
        Text(calc.depositTotalOfUser(member.id).toStringAsFixed(0)),
        Text(
          calc.balanceOfUser(member.id).toStringAsFixed(2),
          style: TextStyle(
            color: calc.balanceOfUser(member.id) > 0
                ? Colors.green
                : calc.balanceOfUser(member.id) < 0
                    ? Colors.red
                    : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  td(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
  }
}
