import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mess/models/models.dart';
import 'package:mess/services/helpers.dart';
import 'package:provider/provider.dart';
import 'package:mess/services/members_service.dart';

class MealsTableViewScreen extends StatefulWidget {
  static const routeName = '/meals-table';

  @override
  _MealsTableViewScreenState createState() => _MealsTableViewScreenState();
}

class _MealsTableViewScreenState extends State<MealsTableViewScreen> {
  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final membersData = Provider.of<MembersService>(context);
    final members = membersData.items;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Meals Table', style: TextStyle(fontSize: 16)),
            Text(
              DateFormat.yMMMM().format(dateTime),
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () async {
              DateTime selectedDate = await showDatePicker(
                context: context,
                initialDate: dateTime,
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (selectedDate == null) return;
              setState(() {
                dateTime = selectedDate;
              });
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              // dividerThickness: 1,
              columns: [
                DataColumn(
                    label: Text('Day',
                        style: Theme.of(context).textTheme.bodyText1),
                    numeric: true),
                ...members
                    .map((member) => DataColumn(
                        label: Text(member.name,
                            style: Theme.of(context).textTheme.bodyText1)))
                    .toList(),
                DataColumn(
                    label: Text('Day',
                        style: Theme.of(context).textTheme.bodyText1),
                    numeric: true),
              ],
              rows: getRows(members),
            ),
          ),
        ],
      ),
    );
  }

  getRows(List<User> members) {
    List<DataRow> rows = [];
    for (var i = 1; i <= lastDayOfMonth(null); i++) {
      rows.add(
        DataRow(cells: [
          DataCell(Text('$i')),
          ...members.map((member) => DataCell(MealsCell())),
          DataCell(Text('$i')),
        ]),
      );
    }
    return rows;
  }

}

class MealsCell extends StatelessWidget {
  final bool breakfast;
  final bool lunch;
  final bool dinner;

  MealsCell({this.breakfast = false, this.lunch = true, this.dinner = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          breakfast ? Icons.check_circle_outline : Icons.cancel,
          size: 18,
          color: breakfast
              ? Theme.of(context).accentColor
              : Theme.of(context).iconTheme.color,
        ),
        SizedBox(width: 4),
        Icon(
          lunch ? Icons.check_circle_outline : Icons.cancel,
          size: 18,
          color: lunch
              ? Theme.of(context).accentColor
              : Theme.of(context).errorColor,
        ),
        SizedBox(width: 4),
        Icon(
          dinner ? Icons.check_circle_outline : Icons.cancel,
          size: 18,
          color: dinner
              ? Theme.of(context).accentColor
              : Theme.of(context).errorColor,
        ),
      ],
    );
  }
}
