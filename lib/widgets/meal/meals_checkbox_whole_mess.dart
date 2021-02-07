import 'package:flutter/material.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/services/meals_service.dart';
import 'package:provider/provider.dart';

class MealsCheckboxWholeMess extends StatefulWidget {
  final bool value;
  final String type;
  final DateTime dateTime;
  MealsCheckboxWholeMess(this.value, this.type, this.dateTime);
  @override
  _MealsCheckboxWholeMessState createState() => _MealsCheckboxWholeMessState();
}

class _MealsCheckboxWholeMessState extends State<MealsCheckboxWholeMess> {
  bool _isLoading = false;
  bool _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final mealsService = Provider.of<MealsService>(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Checkbox(
          value: _value,
          onChanged: auth.user.isManager
              ? (_) async {
                  setState(() {
                    _isLoading = true;
                  });
                  await mealsService
                      .toggleWholeMessMeal(widget.dateTime, widget.type)
                      .then((value) {
                    setState(() {
                      _value = value;
                      _isLoading = false;
                    });
                  }).catchError((error) {
                    showHttpError(context, error);
                    setState(() {
                      _isLoading = false;
                    });
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
