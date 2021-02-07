import 'package:flutter/material.dart';
import 'package:messman/constants.dart';
import 'package:messman/models/http_exception.dart';
import 'package:messman/models/mess.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/services/mess_service.dart';
import 'package:messman/widgets/meal/meal_size_controller.dart';
import 'package:messman/widgets/screen_loading.dart';
import 'package:provider/provider.dart';

class CreateMessScreen extends StatefulWidget {
  static const routeName = '/mess/create';

  @override
  _CreateMessScreenState createState() => _CreateMessScreenState();
}

class _CreateMessScreenState extends State<CreateMessScreen> {
  final _form = GlobalKey<FormState>();
  Mess _mess = Mess();
  bool _isLoading = false;

  void _saveMess() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      final messService = Provider.of<MessService>(context, listen: false);
      if (_mess.id != null) {
        // Update the mess
        await messService.editMess(_mess);
        Navigator.of(context).pop(true);
      } else {
        // Create new mess
        final messId = await messService.createMess(_mess);
        if (messId != null && messId > 0) {
          Provider.of<AuthService>(context, listen: false).messId = messId;
          if (context != null) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false);
          }
        } else {
          showHttpError(
            context,
            new HttpException('Received mess ID is invalid!'),
          );
        }
      }
      return;
    } catch (error) {
      showHttpError(context, error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Mess passedMess = ModalRoute.of(context).settings.arguments;
    if (passedMess != null && passedMess.id != null) {
      _mess = passedMess;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_mess.id != null ? "Edit Mess" : "Create New Mess"),
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _form,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                TextFormField(
                  initialValue: _mess.name,
                  decoration: InputDecoration(
                    labelText: 'Mess Name',
                    hintText: 'ex: The White House',
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Mess name is required!';
                    }
                    return null;
                  },
                  onSaved: (val) => _mess.name = val,
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: _mess.location,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    hintText: 'ex: Panthapath, Dhaka',
                    prefixIcon: Icon(Icons.place),
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Mess location is required!';
                    }
                    return null;
                  },
                  onSaved: (val) => _mess.location = val,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _mess.currencySymbol,
                  decoration: InputDecoration(
                    labelText: 'Currency Symbol',
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                  items: currencies
                      .map((item) => DropdownMenuItem<String>(
                            child: Row(
                              children: <Widget>[
                                Text(item.symbol),
                                SizedBox(width: 5),
                                Text(item.name),
                              ],
                            ),
                            value: item.symbol,
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _mess.currencySymbol = val;
                    });
                  },
                ),
                SizedBox(height: 20),
                MealSizeController(
                  initValue: _mess.breakfastSize ?? 0.5,
                  labelText: 'Breakfast Size',
                  onChanged: (val) {
                    _mess.breakfastSize = double.parse(val);
                  },
                ),
                SizedBox(height: 25),
                RaisedButton.icon(
                  onPressed: _saveMess,
                  icon: Icon(Icons.save),
                  label: Text('Save Mess'),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                ),
              ],
            ),
          ),
          if (_isLoading) ScreenLoading(),
        ],
      ),
    );
  }
}
