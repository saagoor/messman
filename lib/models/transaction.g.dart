// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return Transaction(
    id: json['id'] as int,
    memberId: json['member_id'] as int,
    amount: json['amount'] as int ?? 0,
    dateTime: json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
  );
}

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'amount': instance.amount,
      'date_time': instance.dateTime?.toIso8601String(),
    };
