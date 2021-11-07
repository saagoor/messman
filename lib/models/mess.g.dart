// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mess.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mess _$MessFromJson(Map<String, dynamic> json) {
  return Mess(
    id: json['id'] as int,
    name: json['name'] as String,
    location: json['location'] as String,
    joinCode: json['join_code'] as String,
    allowJoin: json['allow_join'] as bool,
    breakfastSize: (json['breakfast_size'] as num)?.toDouble(),
    currencySymbol: json['currency_symbol'] as String,
    currentMonth: json['current_month'] == null
        ? null
        : DateTime.parse(json['current_month'] as String),
    createdBy: json['created_by'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );
}

Map<String, dynamic> _$MessToJson(Mess instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'join_code': instance.joinCode,
      'allow_join': instance.allowJoin,
      'breakfast_size': instance.breakfastSize,
      'currency_symbol': instance.currencySymbol,
      'current_month': instance.currentMonth?.toIso8601String(),
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
    };
