// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    id: json['id'] as int,
    senderId: json['sender_id'] as int,
    text: json['text'] as String,
    sentAt: json['sent_at'] == null
        ? null
        : DateTime.parse(json['sent_at'] as String),
    status: json['status'] as String ?? 'sending',
    type: json['type'] as String,
    repliedTo: json['replied_to'] as int,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'text': instance.text,
      'sent_at': instance.sentAt?.toIso8601String(),
      'status': instance.status,
      'type': instance.type,
      'replied_to': instance.repliedTo,
    };
