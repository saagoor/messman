
import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Food {
  int id;
  String title;
  String imageUrl;
  String category;
  int likesCount;
  int dislikesCount;

  Food({
    this.id,
    this.title,
    this.imageUrl,
    this.category,
    this.likesCount,
    this.dislikesCount,
  });

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);

}