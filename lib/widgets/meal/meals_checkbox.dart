import 'package:flutter/material.dart';
import 'package:messman/models/meal.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/helpers.dart';
import 'package:provider/provider.dart';

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
    final auth = Provider.of<AuthService>(context);
    final meal = widget.meal;
    final mealType = widget.type;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Checkbox(
          value: (mealType == 'breakfast')
              ? meal.breakfast
              : (mealType == 'lunch')
                  ? meal.lunch
                  : meal.dinner,
          onChanged: canOnOffMeal(auth.user, meal)
              ? (_) async {
                  setState(() {
                    _isLoading = true;
                  });
                  await meal
                      .toggleMeal(mealType, auth.token)
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
