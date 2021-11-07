import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:messman/constants.dart';
import 'package:messman/models/http_exception.dart';
import 'package:messman/models/meal.dart';
import 'package:messman/includes/helpers.dart';
import 'package:http/http.dart' as http;

class MealsService with ChangeNotifier {
  final String token;
  MealsService({
    this.token,
    monthsMealsPrev,
  }) {
    if (monthsMealsPrev != null && monthsMealsPrev.length > 0) {
      this.monthsMeals = monthsMealsPrev;
      isLoaded = true;
    }
  }

  bool isLoaded = false;

  Map<int, DaysMeal> monthsMeals = {};

  void reset({reload = false}) {
    this.monthsMeals = {};
    this.isLoaded = false;
    if (reload) {
      notifyListeners();
    }
  }

  List<MembersMeal> membersMeals(DateTime date) {
    return monthsMeals[date.day]?.membersMeals ?? [];
  }

  Meal breakfast(DateTime date) {
    if (date == null) date = DateTime.now();
    return monthsMeals[date.day]?.breakfast ??
        Meal(type: 'breakfast', date: date);
  }

  Meal lunch(DateTime date) {
    if (date == null) date = DateTime.now();
    return monthsMeals[date.day]?.lunch ?? Meal(type: 'lunch', date: date);
  }

  Meal dinner(DateTime date) {
    if (date == null) date = DateTime.now();
    return monthsMeals[date.day]?.dinner ?? Meal(type: 'dinner', date: date);
  }

  List<MembersMeal> get membersMealsOfMonth {
    List<MembersMeal> allMeals = [];
    monthsMeals.forEach((key, value) {
      allMeals.addAll(value.membersMeals);
    });
    return allMeals;
  }

  Future<void> fetchAndSetMeals() async {
    try {
      final response = await http.get(
        baseUrl + 'meals',
        headers: httpHeader(token),
      );
      if (response.statusCode == 200) {
        this.processMonthsMealsData(response);
      } else {
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } on HttpException catch (error) {
      throw error;
    } catch (error) {
      print(error);
      throw HttpException('Something went wrong, could not load meals!');
    }
  }

  void processMonthsMealsData(http.Response response) {
    final result = json.decode(response.body) as Map<String, dynamic>;
    if (result != null && result['data'] != null) {
      Map<int, DaysMeal> tempMeals = {};
      result['data'].forEach((val) {
        tempMeals.putIfAbsent(val['day'], () => DaysMeal.fromJson(val));
      });
      monthsMeals = tempMeals;
      notifyListeners();
    }
  }

  Future<bool> toggleWholeMessMeal(DateTime dateTime, String type) async {
    try {
      final response = await http.patch(
        baseUrl + 'meals/toggle',
        headers: httpHeader(token),
        body: jsonEncode({'date': dateTime.toIso8601String(), 'type': type}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        this.processMonthsMealsData(response);
        notifyListeners();
        return this.membersMeals(dateTime).every((element) {
          bool value;
          switch (type) {
            case 'breakfast':
              value = element.breakfast;
              break;
            case 'lunch':
              value = element.lunch;
              break;
            case 'dinner':
              value = element.dinner;
              break;
          }
          return value;
        });
      } else {
        handleHttpErrors(response);
      }
      return true;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addGuestMeal(
    DateTime date,
    int memberId,
    double guestCount,
  ) async {
    try {
      final response = await http.post(
        baseUrl + 'meals/guests',
        headers: httpHeader(token),
        body: json.encode({
          'member_id': memberId,
          'guest_count': guestCount,
          'date': DateFormat('yyyy-MM-dd').format(date),
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          if (!monthsMeals.containsKey(date.day)) {
            // Jodi ei diner kono meal na thake tahole age initialize kore nitese
            monthsMeals[date.day] = new DaysMeal();
          }
          result['data'].forEach((item) {
            monthsMeals[date.day].membersMeals.add(MembersMeal.fromJson(item));
          });
          notifyListeners();
        } else {
          throw HttpException('Empty result returned from server!');
        }
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
