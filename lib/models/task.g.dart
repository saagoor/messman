// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    id: json['id'] as int,
    memberId: json['member_id'] as int,
    messId: json['mess_id'] as int,
    title: json['title'] as String,
    dateTime: json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
    status: json['status'] as String ?? 'pending',
    instruction: json['instruction'] as String,
    incompleteFine: json['incomplete_fine'] as int ?? 0,
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'mess_id': instance.messId,
      'title': instance.title,
      'date_time': instance.dateTime?.toIso8601String(),
      'status': instance.status,
      'instruction': instance.instruction,
      'incomplete_fine': instance.incompleteFine,
    };
