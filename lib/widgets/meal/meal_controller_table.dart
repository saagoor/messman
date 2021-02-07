import 'package:flutter/material.dart';
import 'package:messman/models/meal.dart';
import 'package:messman/services/meals_service.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:messman/widgets/meal/meals_checkbox.dart';
import 'package:provider/provider.dart';

import 'meals_checkbox_whole_mess.dart';

class MealControllerTable extends StatefulWidget {
  final DateTime dateTime;
  MealControllerTable(this.dateTime);

  @override
  _MealControllerTableState createState() => _MealControllerTableState();
}

class _MealControllerTableState extends State<MealControllerTable> {
  MembersService _membersData;
  MealsService _mealsData;
  MessService _messData;
  bool _firstInit = true;

  bool _breakfastOn = false;
  bool _lunchOn = false;
  bool _dinnerOn = false;

  void initMealsControll() {
    // Whole mess specific meal on off check
    for (MembersMeal element in _mealsData.membersMeals(widget.dateTime)) {
      if (element.breakfast) _breakfastOn = true;
      if (element.lunch) _lunchOn = true;
      if (element.dinner) _dinnerOn = true;
      if (_breakfastOn && _lunchOn && _dinnerOn) {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _messData = Provider.of<MessService>(context);
    _membersData = Provider.of<MembersService>(context);
    _mealsData = Provider.of<MealsService>(context);

    if (_firstInit) {
      initMealsControll();
      _firstInit = false;
    }

    if (_messData.mess == null) {
      return Text('');
    }

    return Table(
      defaultColumnWidth: FractionColumnWidth(0.2),
      columnWidths: {
        0: FractionColumnWidth(0.4),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(children: [
          Text(''),
          Text(
            _messData.mess.breakfastSize > 0 ? 'Breakfast' : '',
            textAlign: TextAlign.center,
          ),
          Text('Lunch', textAlign: TextAlign.center),
          Text('Dinner', textAlign: TextAlign.center),
        ]),
        TableRow(
          children: [
            Text('Whole Mess'),
            if (_messData.mess.breakfastSize <= 0) Text(''),
            if (_messData.mess.breakfastSize > 0)
              MealsCheckboxWholeMess(
                  _breakfastOn, 'breakfast', widget.dateTime),
            MealsCheckboxWholeMess(_lunchOn, 'lunch', widget.dateTime),
            MealsCheckboxWholeMess(_dinnerOn, 'dinner', widget.dateTime),
          ],
        ),
        ..._mealsData?.membersMeals(widget.dateTime)?.map((theMeal) {
          return _getRow(theMeal);
        })?.toList(),
      ],
    );
  }

  _getRow(MembersMeal meal) {
    final member = _membersData.memberById(meal.memberId);
    int guestNo = 0;
    _mealsData.membersMeals(widget.dateTime).forEach((element) {
      if (element.id < meal.id && element.memberId == meal.memberId) {
        guestNo++;
      }
    });
    return TableRow(
      children: [
        Text(member.name + (guestNo > 0 ? '\'s Guest $guestNo' : '')),
        if (_messData.mess.breakfastSize <= 0) Text(''),
        if (_messData.mess.breakfastSize > 0)
          ChangeNotifierProvider<MembersMeal>.value(
            value: meal,
            child: Consumer<MembersMeal>(
              builder: (ctx, meal, child) => MealsCheckbox(meal, 'breakfast'),
            ),
          ),
        ChangeNotifierProvider<MembersMeal>.value(
          value: meal,
          child: Consumer<MembersMeal>(
            builder: (ctx, meal, child) => MealsCheckbox(meal, 'lunch'),
          ),
        ),
        ChangeNotifierProvider<MembersMeal>.value(
          value: meal,
          child: Consumer<MembersMeal>(
            builder: (ctx, meal, child) => MealsCheckbox(meal, 'dinner'),
          ),
        ),
      ],
    );
  }
}
