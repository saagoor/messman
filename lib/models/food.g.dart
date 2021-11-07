// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

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
