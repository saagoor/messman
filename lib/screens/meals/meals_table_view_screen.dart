import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/models/user.dart';
import 'package:messman/services/calc_service.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/services/meals_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';
import 'package:messman/services/members_service.dart';

class MealsTableViewScreen extends StatefulWidget {
  static const routeName = '/meals-table';

  @override
  _MealsTableViewScreenState createState() => _MealsTableViewScreenState();
}

class _MealsTableViewScreenState extends State<MealsTableViewScreen> {
  DateTime dateTime = DateTime.now();
  double _tableHeadHeight = 0;
  double _tableHeadOpacity = 0;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && _tableHeadOpacity == 0) {
        setState(() {
          _tableHeadHeight = 42;
          _tableHeadOpacity = 1;
        });
      } else if (_scrollController.offset < 80 && _tableHeadOpacity != 0) {
        setState(() {
          _tableHeadHeight = 0;
          _tableHeadOpacity = 0;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.more_horiz),
        //     onPressed: () async {
        //       // DateTime selectedDate = await showDatePicker(
        //       //   context: context,
        //       //   initialDate: dateTime,
        //       //   firstDate: DateTime.now().subtract(Duration(days: 365)),
        //       //   lastDate: DateTime.now().add(Duration(days: 365)),
        //       // );
        //       // if (selectedDate == null) return;
        //       // setState(() {
        //       //   dateTime = selectedDate;
        //       // });
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: <Widget>[
            AnimatedOpacity(
              opacity: _tableHeadOpacity,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: AnimatedContainer(
                color: Theme.of(context).primaryColorLight,
                height: _tableHeadHeight,
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 500),
                child: Table(
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [getTableHeads(members)],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: ChangeNotifierProvider.value(
                  value: CalcService(context),
                  child: Table(
                    defaultColumnWidth: IntrinsicColumnWidth(),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      getTableHeads(members),
                      ...getRows(members),
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12.0, 0, 12),
                            child: Text('Total:'),
                          ),
                          ...members
                              .map((member) => Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child:
                                        MembersMealsCount(memberId: member.id),
                                  ))
                              .toList(),
                          if (members.length > 3)
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12.0, 0, 12),
                              child: Text(''),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getTableHeads(List<User> members) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Day',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        ...members
            .map((member) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    member.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ))
            .toList(),
        if (members.length > 3)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Day',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
      ],
    );
  }

  getRows(List<User> members) {
    final int today = DateTime.now().day;
    List<TableRow> rows = [];
    for (var i = 1; i <= lastDayOfMonth(null); i++) {
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('$i', textAlign: TextAlign.center),
            ),
            ...members.map(
              (member) => Padding(
                padding: const EdgeInsets.all(12.0),
                child: today < i
                    ? Text('-', textAlign: TextAlign.center)
                    : MealsCell(day: i, memberId: member.id),
              ),
            ),
            if (members.length > 3)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('$i'),
              ),
          ],
        ),
      );
    }
    return rows;
  }
}

class MealsCell extends StatelessWidget {
  final int day;
  final int memberId;
  MealsCell({this.day, this.memberId});

  @override
  Widget build(BuildContext context) {
    final messService = Provider.of<MessService>(context);
    final mealsService = Provider.of<MealsService>(context);
    double mealCount = mealsService
        .membersMeals(DateTime(DateTime.now().year, DateTime.now().month, day))
        .fold(0, (prevValue, item) {
      if (item.memberId == memberId) {
        if (item.breakfast) prevValue += messService.mess?.breakfastSize ?? 0;
        if (item.lunch) prevValue++;
        if (item.dinner) prevValue++;
      }
      return prevValue;
    });
    return Text('${smartCount(mealCount)}', textAlign: TextAlign.center);
  }
}

class MembersMealsCount extends StatelessWidget {
  final int memberId;
  const MembersMealsCount({Key key, @required this.memberId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calcService = Provider.of<CalcService>(context);
    final count = calcService.totalMealsCountOfUser(memberId);
    return Text(
      '${smartCount(count)}',
      style: TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
