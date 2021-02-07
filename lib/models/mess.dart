import 'package:json_annotation/json_annotation.dart';
part 'mess.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Mess {
  int id;
  String name;
  String location;
  String joinCode;
  bool allowJoin;
  double breakfastSize;
  String currencySymbol;
  DateTime currentMonth;
  int createdBy;
  DateTime createdAt;

  Mess({
    this.id,
    this.name,
    this.location,
    this.joinCode,
    this.allowJoin,
    this.breakfastSize = 0.5,
    this.currencySymbol = '৳',
    this.currentMonth,
    this.createdBy,
    this.createdAt,
  });

  factory Mess.fromJson(Map<String, dynamic> json) => _$MessFromJson(json);
  Map<String, dynamic> toJson() => _$MessToJson(this);
}
