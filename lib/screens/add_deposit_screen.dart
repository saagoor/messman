import 'package:flutter/material.dart';
import 'package:mess/models/models.dart';
import 'package:mess/services/auth_service.dart';
import 'package:mess/services/deposits_service.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/services/members_service.dart';
import 'package:mess/services/mess_service.dart';
import 'package:mess/widgets/input_date_picker.dart';
import 'package:mess/widgets/member_selector.dart';
import 'package:provider/provider.dart';

class AddDepositScreen extends StatefulWidget {
  static const routeName = '/deposits/add';
  @override
  _AddDepositScreenState createState() => _AddDepositScreenState();
}

class _AddDepositScreenState extends State<AddDepositScreen> {
  final _form = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();

  final now = DateTime.now();
  bool _isLoading = false;

  Deposit _deposit = Deposit(
    dateTime: DateTime.now(),
  );

  void _saveForm() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    // Save Deposit
    await Provider.of<DepositsService>(context, listen: false)
        .addDeposit(_deposit)
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
    if (_deposit.dateTime.isAfter(oneMonthLater)) {
      return _deposit.dateTime;
    }
    return oneMonthLater;
  }

  @override
  Widget build(BuildContext context) {
    final messService = Provider.of<MessService>(context);
    final membersService = Provider.of<MembersService>(context);
    final authService = Provider.of<AuthService>(context);
    if (!membersService.isLoaded) {
      membersService.fetchAndSet().catchError((error) {
        showHttpError(context, error);
      });
    }
    if (_deposit.memberId == null) {
      _deposit.memberId = authService.user.id;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add New Deposit')),
      body: Stack(
        children: <Widget>[
          Form(
            key: _form,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      InputDatePicker(
                        value: _deposit.dateTime,
                        firstDate: messService.mess?.currentMonth,
                        lastDate: _getLastDate(messService.mess?.currentMonth),
                        onSelect: (val) {
                          setState(() {
                            _deposit.dateTime = val;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      MemberSelector(
                        labelText: 'Deposited By',
                        initialId: _deposit.memberId,
                        onChanged: (int selectedMemberId) {
                          _deposit.memberId = selectedMemberId;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue:
                            (_deposit.amount != null) && (_deposit.amount > 0)
                                ? _deposit.amount.toString()
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
                        onSaved: (val) => _deposit.amount = int.parse(val),
                        onFieldSubmitted: (_) => _saveForm(),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: RaisedButton.icon(
                          icon: Icon(Icons.save),
                          label: Text('Save Deposit'),
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
