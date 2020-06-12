import 'package:flutter/material.dart';
import 'package:mess/services/auth_service.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/services/meals_service.dart';
import 'package:mess/widgets/meal_size_controller.dart';
import 'package:mess/widgets/member_selector.dart';
import 'package:mess/widgets/screen_loading.dart';
import 'package:provider/provider.dart';

class AddGuestMeal extends StatefulWidget {
  final DateTime date;
  const AddGuestMeal({
    Key key,
    @required this.date,
  }) : super(key: key);

  @override
  _AddGuestMealState createState() => _AddGuestMealState();
}

class _AddGuestMealState extends State<AddGuestMeal> {
  int _memberId;
  double _guestCount = 1;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    _memberId = auth.user.id;

    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: <Widget>[
              Text(
                'Add Extra Meal',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 30),
              MemberSelector(
                initialId: _memberId,
                onChanged: (int selectedMemberId) {
                  _memberId = selectedMemberId;
                },
              ),
              SizedBox(height: 20),
              MealSizeController(
                labelText: 'Number of Guest',
                initValue: _guestCount,
                figure: 1,
                maxSize: 10,
                minSize: 1,
                onChanged: (val) {
                  _guestCount = double.parse(val);
                },
              ),
              SizedBox(height: 20),
              FlatButton(
                child: Text('Add Meal'),
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  Provider.of<MealsService>(context, listen: false)
                      .addGuestMeal(widget.date, _memberId, _guestCount)
                      .then((value) => Navigator.of(context).pop())
                      .catchError((error) {
                    setState(() {
                      _isLoading = false;
                    });
                    showHttpError(context, error);
                  });
                },
              ),
            ],
          ),
        ),
        if (_isLoading) ScreenLoading(),
      ],
    );
  }
}
