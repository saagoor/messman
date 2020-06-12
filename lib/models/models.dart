import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

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


@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Expense {
  int id;
  String shortDetails;
  int amount;
  @JsonKey(defaultValue: 'shopping')
  String type;
  int expenderId;
  @JsonKey(defaultValue: false)
  bool fromSelfPocket;
  DateTime dateTime;

  Expense({
    this.id,
    this.shortDetails,
    this.amount,
    this.type,
    this.expenderId,
    this.fromSelfPocket = false,
    this.dateTime,
  });

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Deposit {
  int id;
  int amount;
  int memberId;
  DateTime dateTime;

  Deposit({
    this.id,
    this.amount,
    this.memberId,
    this.dateTime,
  });

  factory Deposit.fromJson(Map<String, dynamic> json) =>
      _$DepositFromJson(json);

  Map<String, dynamic> toJson() => _$DepositToJson(this);
}
