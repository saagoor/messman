import 'package:flutter/material.dart';
import 'package:mess/constants.dart';
import 'package:mess/models/models.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/services/mess_service.dart';
import 'package:mess/widgets/meal_size_controller.dart';
import 'package:mess/widgets/screen_loading.dart';
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
    await Provider.of<MessService>(context, listen: false).createMess(_mess).then((value){
      Navigator.of(context).pushReplacementNamed('/');
    }).catchError((error){
      setState(() {
        _isLoading = false;
      });
      showHttpError(context, error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Mess'),
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _form,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                TextFormField(
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
                  decoration: InputDecoration(
                    labelText: 'Location',
                    hintText: 'ex: Panthapath, Dhaka',
                    prefixIcon: Icon(Icons.place),
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Mess name is required!';
                    }
                    return null;
                  },
                  onSaved: (val) => _mess.location,
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
                      borderRadius: BorderRadius.circular(10),),
                  padding: EdgeInsets.all(10),
                ),
              ],
            ),
          ),
          if(_isLoading)
          ScreenLoading(),
        ],
      ),
    );
  }
}
