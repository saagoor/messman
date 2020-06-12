// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mess _$MessFromJson(Map<String, dynamic> json) {
  return Mess(
    id: json['id'] as int,
    name: json['name'] as String,
    location: json['location'] as String,
    joinCode: json['join_code'] as String,
    allowJoin: json['allow_join'] as bool,
    breakfastSize: (json['breakfast_size'] as num)?.toDouble(),
    currencySymbol: json['currency_symbol'] as String,
    currentMonth: json['current_month'] == null
        ? null
        : DateTime.parse(json['current_month'] as String),
    createdBy: json['created_by'] as int,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
  );
}

Map<String, dynamic> _$MessToJson(Mess instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'join_code': instance.joinCode,
      'allow_join': instance.allowJoin,
      'breakfast_size': instance.breakfastSize,
      'currency_symbol': instance.currencySymbol,
      'current_month': instance.currentMonth?.toIso8601String(),
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    imageUrl: json['image_url'] as String,
    messId: json['mess_id'] as int,
    isManager: json['is_manager'] as bool ?? true,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'image_url': instance.imageUrl,
      'mess_id': instance.messId,
      'is_manager': instance.isManager,
    };

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return Expense(
    id: json['id'] as int,
    shortDetails: json['short_details'] as String,
    amount: json['amount'] as int,
    type: json['type'] as String ?? 'shopping',
    expenderId: json['expender_id'] as int,
    fromSelfPocket: json['from_self_pocket'] as bool ?? false,
    dateTime: json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
  );
}

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'short_details': instance.shortDetails,
      'amount': instance.amount,
      'type': instance.type,
      'expender_id': instance.expenderId,
      'from_self_pocket': instance.fromSelfPocket,
      'date_time': instance.dateTime?.toIso8601String(),
    };

Deposit _$DepositFromJson(Map<String, dynamic> json) {
  return Deposit(
    id: json['id'] as int,
    amount: json['amount'] as int,
    memberId: json['member_id'] as int,
    dateTime: json['date_time'] == null
        ? null
        : DateTime.parse(json['date_time'] as String),
  );
}

Map<String, dynamic> _$DepositToJson(Deposit instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'member_id': instance.memberId,
      'date_time': instance.dateTime?.toIso8601String(),
    };
