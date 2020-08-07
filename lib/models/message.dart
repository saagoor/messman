import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Message {
  int id;
  int senderId;
  String text;
  DateTime sentAt;
  String status;

  Message({
    this.id,
    this.senderId,
    this.text,
    this.sentAt,
    this.status = 'sending',
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
