import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Message {
  final int id;
  final int senderId;
  final String text;
  DateTime sentAt;
  @JsonKey(defaultValue: 'sending')
  String status;
  final String type;
  final int repliedTo;

  Message({
    this.id,
    this.senderId,
    this.text,
    this.sentAt,
    this.status = 'sending',
    this.type,
    this.repliedTo,
  }) {
    if (this.sentAt == null) {
      this.sentAt = DateTime.now();
    }
  }

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
