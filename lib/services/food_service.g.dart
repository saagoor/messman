// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Food _$FoodFromJson(Map<String, dynamic> json) {
  return Food(
    id: json['id'] as int,
    title: json['title'] as String,
    imageUrl: json['image_url'] as String,
    category: json['category'] as String,
    likesCount: json['likes_count'] as int,
    dislikesCount: json['dislikes_count'] as int,
  );
}

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image_url': instance.imageUrl,
      'category': instance.category,
      'likes_count': instance.likesCount,
      'dislikes_count': instance.dislikesCount,
    };

DailyFoodsService _$DailyFoodsServiceFromJson(Map<String, dynamic> json) {
  return DailyFoodsService(
    dateTime: json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
    breakfast: json['breakfast'] as String,
    lunch: json['lunch'] as String,
    dinner: json['dinner'] as String,
  )
    ..id = json['id'] as int
    ..messId = json['mess_id'] as int
    ..breakfastReact = json['breakfast_react'] as int
    ..lunchReact = json['lunch_react'] as int
    ..dinnerReact = json['dinner_react'] as int;
}

Map<String, dynamic> _$DailyFoodsServiceToJson(DailyFoodsService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mess_id': instance.messId,
      'date_time': instance.dateTime?.toIso8601String(),
      'breakfast': instance.breakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
      'breakfast_react': instance.breakfastReact,
      'lunch_react': instance.lunchReact,
      'dinner_react': instance.dinnerReact,
    };
