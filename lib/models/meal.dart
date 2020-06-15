import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mess/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mess/models/http_exception.dart';
import 'package:mess/services/helpers.dart';
import 'package:mess/models/food.dart';

part 'meal.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)

class Meal with ChangeNotifier {
  int id;
  int messId;
  Food food;
  DateTime date;
  String type;
  int likes;
  int dislikes;
  bool likedByUser;

  Meal({
    this.id,
    this.messId,
    this.food,
    this.date,
    this.type,
    this.likes,
    this.dislikes,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);

  void like(){

  }

  void dislike(){

  }
  
}



@JsonSerializable(fieldRename: FieldRename.snake)
class MembersMeal with ChangeNotifier {
  int id;
  int memberId;
  int messId;
  DateTime date;
  bool breakfast;
  bool lunch;
  bool dinner;

  MembersMeal({
    this.id,
    this.memberId,
    this.messId,
    this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  factory MembersMeal.fromJson(Map<String, dynamic> json) =>
      _$MembersMealFromJson(json);
  Map<String, dynamic> toJson() => _$MembersMealToJson(this);

  Future<void> toggleMeal(String mealType, String token) async {
    try {
      final response = await http.patch(
        baseUrl + 'meals/toggle/$id',
        headers: httpHeader(token),
        body: json.encode({'meal': mealType}),
      );
      if (response.statusCode == 200) {
        switch (mealType) {
          case 'breakfast':
            breakfast = !breakfast;
            break;
          case 'lunch':
            lunch = !lunch;
            break;
          case 'dinner':
            dinner = !dinner;
            break;
        }
        notifyListeners();
      } else {
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
      throw error;
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DaysMeal{
  final List<MembersMeal> membersMeals;
  final Map<String, Meal> messMeals;
  DaysMeal({
    this.messMeals,
    this.membersMeals,
  });

  factory DaysMeal.fromJson(Map<String, dynamic> json) =>
      _$DaysMealFromJson(json);
  Map<String, dynamic> toJson() => _$DaysMealToJson(this);
}
