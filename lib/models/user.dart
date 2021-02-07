import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  int id;
  String name;
  String email;
  String phone;
  String imageUrl;
  int messId;
  @JsonKey(defaultValue: true)
  bool isManager;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.imageUrl,
    this.messId,
    this.isManager = true,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
