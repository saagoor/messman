// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return Expense(
    id: json['id'] as int,
    shortDetails: json['short_details'] as String,
    amount: json['amount'] as int ?? 0,
    type: json['type'] as String ?? 'shopping',
    memberId: json['member_id'] as int,
    fromSelfPocket: json['from_self_pocket'] as bool ?? false,
    dateTime: json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
  );
}

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'amount': instance.amount,
      'date_time': instance.dateTime?.toIso8601String(),
      'short_details': instance.shortDetails,
      'type': instance.type,
      'from_self_pocket': instance.fromSelfPocket,
    };
