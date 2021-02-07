import 'package:flutter/material.dart';
import 'package:messman/models/transaction.dart';
import 'package:messman/services/expenses_service.dart';
import 'package:provider/provider.dart';

import 'package:json_annotation/json_annotation.dart';
part 'expense.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Expense extends Transaction {
  String shortDetails;
  @JsonKey(defaultValue: 'shopping')
  String type;
  @JsonKey(defaultValue: false)
  bool fromSelfPocket;

  Expense({
    int id,
    this.shortDetails,
    int amount,
    this.type,
    int memberId,
    this.fromSelfPocket = false,
    DateTime dateTime,
  }) : super(
          id: id,
          memberId: memberId,
          amount: amount,
          dateTime: dateTime,
        );

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  void delete(BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        actionsPadding: EdgeInsets.only(right: 10),
        title: Text('Delete Expense!'),
        content: Text('Do you want to delete this expense?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          FlatButton(
            color: Theme.of(context).errorColor,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Delete'),
          )
        ],
      ),
    );
    if (confirmDelete) {
      Provider.of<ExpensesService>(context, listen: false)
          .delete(super.id)
          .then((value) {
        if (context != null && value == true) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Expense deleted successfully!')),
          );
        }
      }).catchError((error) {
        if (context != null) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }
      });
    }
  }
}
