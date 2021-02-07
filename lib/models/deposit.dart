import 'package:flutter/material.dart';
import 'package:messman/models/transaction.dart';
import 'package:json_annotation/json_annotation.dart';
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
}
