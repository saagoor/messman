import 'package:flutter/material.dart';
import 'package:messman/models/meal.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/services/meals_service.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';

class MealControllerTable extends StatefulWidget {
  final DateTime dateTime;
  MealControllerTable(this.dateTime);

  @override
  _MealControllerTableState createState() => _MealControllerTableState();
}

class _MealControllerTableState extends State<MealControllerTable> {
  MembersService _membersData;
  AuthService _authData;
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
    _messData = Provider.of<MessService>(context, listen: false);
    _membersData = Provider.of<MembersService>(context, listen: false);
    _authData = Provider.of<AuthService>(context);
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
          Text('Member'),
          if (_messData.mess.breakfastSize <= 0) Text(''),
          if (_messData.mess.breakfastSize > 0)
            Text('Breakfast', textAlign: TextAlign.center),
          Text('Lunch', textAlign: TextAlign.center),
          Text('Dinner', textAlign: TextAlign.center),
        ]),
        TableRow(
          children: [
            Text('Whole Mess'),
            if (_messData.mess.breakfastSize <= 0) Text(''),
            if (_messData.mess.breakfastSize > 0)
              Checkbox(
                value: _breakfastOn,
                onChanged: (_) {
                  if (_authData.user.isManager) {
                    bool value =
                        _mealsData.toggleWholeMessBreakfast(widget.dateTime);
                    setState(() {
                      _breakfastOn = value;
                    });
                  }
                },
              ),
            Checkbox(
              value: _lunchOn,
              onChanged: (_) {
                if (_authData.user.isManager) {
                  final bool value =
                      _mealsData.toggleWholeMessLunch(widget.dateTime);
                  setState(() {
                    _lunchOn = value;
                  });
                }
              },
            ),
            Checkbox(
              value: _dinnerOn,
              onChanged: (_) {
                if (_authData.user.isManager) {
                  bool value =
                      _mealsData.toggleWholeMessDinner(widget.dateTime);
                  setState(() {
                    _dinnerOn = value;
                  });
                }
              },
            ),
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

class MealsCheckbox extends StatefulWidget {
  final MembersMeal meal;
  final String type;
  MealsCheckbox(this.meal, this.type);
  @override
  _MealsCheckboxState createState() => _MealsCheckboxState();
}

class _MealsCheckboxState extends State<MealsCheckbox> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthService>(context);
    final meal = widget.meal;
    final mealType = widget.type;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Checkbox(
          value: (mealType == 'breakfast')
              ? meal.breakfast
              : (mealType == 'lunch') ? meal.lunch : meal.dinner,
          onChanged: canOnOffMeal(_authData.user, meal)
              ? (_) async {
                  setState(() {
                    _isLoading = true;
                  });
                  await meal
                      .toggleMeal(mealType, _authData.token)
                      .catchError((error) {
                    showHttpError(context, error);
                  });
                  setState(() {
                    _isLoading = false;
                  });
                }
              : null,
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
