import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mess/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mess/models/http_exception.dart';
import 'package:mess/services/helpers.dart';

part 'daily_meal.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DailyMeal with ChangeNotifier {
  int id;
  int memberId;
  int messId;
  DateTime date;
  bool breakfast;
  bool lunch;
  bool dinner;

  DailyMeal({
    this.memberId,
    this.messId,
    this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  factory DailyMeal.fromJson(Map<String, dynamic> json) =>
      _$DailyMealFromJson(json);
  Map<String, dynamic> toJson() => _$DailyMealToJson(this);

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
        handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
      throw error;
    }
  }
}
