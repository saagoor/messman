import 'package:flutter/material.dart';
import 'package:messman/includes/dialogs.dart';
import 'package:messman/models/transaction.dart';
import 'package:messman/screens/save_expense_screen.dart';
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

  void delete(BuildContext context) {
    showConfirmationDialog(
      context: context,
      deleteMethod: () =>
          Provider.of<ExpensesService>(context, listen: false).delete(super.id),
      title: 'Delete Expense!',
      content: 'Are you sure you want to delete this expense?',
      successMessage: 'Expense deleted successfully!',
    );
  }

  void edit(BuildContext context) async {
    final hasSaved = await Navigator.of(context).pushNamed(
      SaveExpenseScreen.routeName,
      arguments: this,
    );
    if (hasSaved == true) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Expense saved successfully!')),
      );
    }
  }
}
