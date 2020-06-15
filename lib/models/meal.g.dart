// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) {
  return Meal(
    id: json['id'] as int,
    messId: json['mess_id'] as int,
    food: json['food'] == null
        ? null
        : Food.fromJson(json['food'] as Map<String, dynamic>),
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    type: json['type'] as String,
    likes: json['likes'] as int,
    dislikes: json['dislikes'] as int,
  )..likedByUser = json['liked_by_user'] as bool;
}

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'id': instance.id,
      'mess_id': instance.messId,
      'food': instance.food?.toJson(),
      'date': instance.date?.toIso8601String(),
      'type': instance.type,
      'likes': instance.likes,
      'dislikes': instance.dislikes,
      'liked_by_user': instance.likedByUser,
    };

MembersMeal _$MembersMealFromJson(Map<String, dynamic> json) {
  return MembersMeal(
    id: json['id'] as int,
    memberId: json['member_id'] as int,
    messId: json['mess_id'] as int,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    breakfast: json['breakfast'] as bool,
    lunch: json['lunch'] as bool,
    dinner: json['dinner'] as bool,
  );
}

Map<String, dynamic> _$MembersMealToJson(MembersMeal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'mess_id': instance.messId,
      'date': instance.date?.toIso8601String(),
      'breakfast': instance.breakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
    };

DaysMeal _$DaysMealFromJson(Map<String, dynamic> json) {
  return DaysMeal(
    messMeals: (json['mess_meals'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k, e == null ? null : Meal.fromJson(e as Map<String, dynamic>)),
    ),
    membersMeals: (json['members_meals'] as List)
        ?.map((e) =>
            e == null ? null : MembersMeal.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DaysMealToJson(DaysMeal instance) => <String, dynamic>{
      'members_meals': instance.membersMeals?.map((e) => e?.toJson())?.toList(),
      'mess_meals': instance.messMeals?.map((k, e) => MapEntry(k, e?.toJson())),
    };
