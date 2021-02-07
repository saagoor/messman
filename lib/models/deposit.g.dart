// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Deposit _$DepositFromJson(Map<String, dynamic> json) {
  return Deposit(
    id: json['id'] as int,
    amount: json['amount'] as int ?? 0,
    memberId: json['member_id'] as int,
    dateTime: json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
  );
}

Map<String, dynamic> _$DepositToJson(Deposit instance) => <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'amount': instance.amount,
      'date_time': instance.dateTime?.toIso8601String(),
    };
