import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
part 'transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Transaction {
  int id;
  int memberId;
  @JsonKey(defaultValue: 0)
  int amount;
  DateTime dateTime;

  Transaction({
    this.id,
    this.memberId,
    this.amount,
    this.dateTime,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  void delete(BuildContext context) {
    print('Executing from parent transaction class');
  }

  void edit(BuildContext context) async {
    print('Executing from parent transaction class');
  }
}
