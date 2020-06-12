// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyMeal _$DailyMealFromJson(Map<String, dynamic> json) {
  return DailyMeal(
    memberId: json['member_id'] as int,
    messId: json['mess_id'] as int,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    breakfast: json['breakfast'] as bool,
    lunch: json['lunch'] as bool,
    dinner: json['dinner'] as bool,
  )..id = json['id'] as int;
}

Map<String, dynamic> _$DailyMealToJson(DailyMeal instance) => <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'mess_id': instance.messId,
      'date': instance.date?.toIso8601String(),
      'breakfast': instance.breakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
    };
