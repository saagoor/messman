import 'package:flutter/material.dart';
import 'package:messman/includes/dialogs.dart';
import 'package:messman/models/transaction.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:messman/screens/save_deposit_screen.dart';
import 'package:messman/services/deposits_service.dart';
import 'package:provider/provider.dart';
part 'deposit.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Deposit extends Transaction {
  Deposit({
    int id,
    int amount,
    int memberId,
    DateTime dateTime,
  }) : super(
          id: id,
          memberId: memberId,
          amount: amount,
          dateTime: dateTime,
        );

  factory Deposit.fromJson(Map<String, dynamic> json) =>
      _$DepositFromJson(json);

  Map<String, dynamic> toJson() => _$DepositToJson(this);

  void delete(BuildContext context) {
    showDeleteDialog(
      context: context,
      deleteMethod: () =>
          Provider.of<DepositsService>(context, listen: false).delete(super.id),
      title: 'Delete Deposit!',
      content: 'Are sure you want to delete this deposit?',
      successMessage: 'Deposit deleted successfully!',
    );
  }

  void edit(BuildContext context) async {
    final hasSaved = await Navigator.of(context).pushNamed(
      SaveDepositScreen.routeName,
      arguments: this,
    );
    if (hasSaved == true) {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text('Deposit saved successfully!')),
      );
    }
  }
}
