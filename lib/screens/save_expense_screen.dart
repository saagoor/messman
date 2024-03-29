import 'package:flutter/material.dart';
import 'package:messman/models/expense.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/expenses_service.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/services/mess_service.dart';
import 'package:messman/widgets/input_date_picker.dart';
import 'package:messman/widgets/user/member_selector.dart';
import 'package:provider/provider.dart';

class SaveExpenseScreen extends StatefulWidget {
  static const routeName = '/expenses/save';

  @override
  _SaveExpenseScreenState createState() => _SaveExpenseScreenState();
}

class _SaveExpenseScreenState extends State<SaveExpenseScreen> {
  final _form = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();

  final now = DateTime.now();
  bool _isLoading = false;

  Expense _expense = Expense(
    shortDetails: '',
    type: 'shopping',
    dateTime: DateTime.now(),
    fromSelfPocket: false,
  );

  void _saveForm() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    // Save expense
    await Provider.of<ExpensesService>(context, listen: false)
        .saveExpense(_expense)
        .then((value) {
      Navigator.of(context).pop(true);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      return showHttpError(context, error);
    });
  }

  DateTime _getLastDate(DateTime currentMonth) {
    if (currentMonth == null) {
      currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    }
    final oneMonthLater =
        currentMonth.add(Duration(days: lastDayOfMonth(currentMonth)));
    if (_expense.dateTime.isAfter(oneMonthLater)) {
      return _expense.dateTime;
    }
    return oneMonthLater;
  }

  @override
  Widget build(BuildContext context) {
    final passedExpense = ModalRoute.of(context).settings.arguments as Expense;
    if (passedExpense != null) {
      _expense = passedExpense;
    }

    final messService = Provider.of<MessService>(context);
    final authService = Provider.of<AuthService>(context);

    if (_expense.memberId == null) {
      _expense.memberId = authService.user.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text((_expense.id != null ? 'Edit' : 'Add New') + ' Expense'),
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _form,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              children: <Widget>[
                SwitchListTile(
                  value: _expense.fromSelfPocket,
                  onChanged: (val) {
                    setState(() {
                      _expense.fromSelfPocket = val;
                    });
                  },
                  title: Text('Add to Deposit'),
                  subtitle: Text(
                      'Enable this if the expense was spent from self pocket not from the mess\'s cash.'),
                  isThreeLine: true,
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.loose,
                      child: RadioListTile(
                        value: 'shopping',
                        groupValue: _expense.type,
                        onChanged: (val) {
                          setState(() {
                            _expense.type = val;
                          });
                        },
                        title: Text('Shopping'),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: RadioListTile(
                        value: 'utility',
                        groupValue: _expense.type,
                        onChanged: (val) {
                          setState(() {
                            _expense.type = val;
                          });
                        },
                        title: Text('Utility'),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      InputDatePicker(
                        value: _expense.dateTime,
                        firstDate: messService.mess?.currentMonth,
                        lastDate: _getLastDate(messService.mess?.currentMonth),
                        onSelect: (val) {
                          setState(() {
                            _expense.dateTime = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      MemberSelector(
                        labelText: 'Expended By',
                        initialId: _expense.memberId,
                        onChanged: (int selectedMemberId) {
                          _expense.memberId = selectedMemberId;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: _expense.shortDetails,
                        decoration: InputDecoration(
                          labelText: 'Short Details',
                          hintText:
                              'ex: ${_expense.type == 'shopping' ? 'Grocery & Vegetables' : 'Internet Bill'}',
                          prefixIcon: Icon(Icons.info_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_amountFocusNode),
                        onSaved: (val) => _expense.shortDetails = val,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue:
                            (_expense.amount != null) && (_expense.amount > 0)
                                ? _expense.amount.toString()
                                : '',
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        focusNode: _amountFocusNode,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Amount cannot be empty!';
                          } else if (int.tryParse(val) == null) {
                            return 'Amount must be a number!';
                          } else if (int.parse(val) <= 0) {
                            return 'Amount must be greater than zero!';
                          }
                          return null;
                        },
                        onSaved: (val) => _expense.amount = int.parse(val),
                        onFieldSubmitted: (_) => _saveForm(),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: RaisedButton.icon(
                          icon: Icon(Icons.save),
                          label: Text('Save Expense'),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onPressed: _saveForm,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountFocusNode.dispose();
    super.dispose();
  }
}
