import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:messman/constants.dart';
import 'package:http/http.dart' as http;
import 'package:messman/models/http_exception.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/models/food.dart';

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

  Future<void> like(String token) async {
    bool oldValue = likedByUser;
    if (likedByUser == null) {
      // Previusly no reaction
      likes++;
      likedByUser = true;
    } else if (!likedByUser) {
      // Previusly disliked
      dislikes--;
      likes++;
      likedByUser = true;
    } else if (likedByUser) {
      // Previusly liked
      likes--;
      likedByUser = null;
    }

    notifyListeners();

    try {
      final response = await http.post(
        baseUrl + 'meal/$id/like',
        headers: httpHeader(token),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          final newMeal = Meal.fromJson(result['data']);
          return updateSelf(newMeal);
        }
      } else {
        likedByUser = oldValue;
        notifyListeners();
        return handleHttpErrors(response);
      }
    } catch (error) {
      likedByUser = oldValue;
      notifyListeners();
      throw error;
    }
  }

  Future<void> dislike(String token) async {
    bool oldValue = likedByUser;
    if (likedByUser == null) {
      // Previusly no reaction
      dislikes++;
      likedByUser = false;
    } else if (likedByUser) {
      // Previusly liked
      likes--;
      dislikes++;
      likedByUser = false;
    } else if (!likedByUser) {
      // Previusly disliked
      dislikes--;
      likedByUser = null;
    }
    notifyListeners();
    try {
      final response = await http.delete(
        baseUrl + 'meal/$id/like',
        headers: httpHeader(token),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          final newMeal = Meal.fromJson(result['data']);
          return updateSelf(newMeal);
        }
      } else {
        likedByUser = oldValue;
        notifyListeners();
        return handleHttpErrors(response);
      }
    } catch (error) {
      likedByUser = oldValue;
      notifyListeners();
      throw error;
    }
  }

  Future<void> setFood(Food newFood, String token) async {
    final oldFood = food;
    food = newFood;
    print(food?.title);
    notifyListeners();
    try {
      final response = await http.post(
        baseUrl + 'meal/setfood',
        headers: httpHeader(token),
        body: json.encode({
          'type': type,
          'date': DateFormat('yyyy-MM-dd').format(date),
          'food_id': newFood.id,
        }),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          final newMeal = Meal.fromJson(result['data']);
          return updateSelf(newMeal);
        }
      } else {
        food = oldFood;
        notifyListeners();
        return handleHttpErrors(response);
      }
    } catch (error) {
      food = oldFood;
      notifyListeners();
      throw error;
    }
  }

  void updateSelf(Meal newSelf) {
    id = newSelf.id;
    food = newSelf.food;
    likes = newSelf.likes;
    dislikes = newSelf.dislikes;
    likedByUser = newSelf.likedByUser;
    notifyListeners();
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
class DaysMeal {
  final List<MembersMeal> membersMeals;
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;

  DaysMeal({this.membersMeals, this.breakfast, this.lunch, this.dinner});

  factory DaysMeal.fromJson(Map<String, dynamic> json) =>
      _$DaysMealFromJson(json);
  Map<String, dynamic> toJson() => _$DaysMealToJson(this);
}
