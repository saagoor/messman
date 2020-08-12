import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:messman/constants.dart';
import 'package:messman/models/http_exception.dart';
import 'package:messman/models/meal.dart';
import 'package:messman/services/helpers.dart';
import 'package:http/http.dart' as http;

class MealsService with ChangeNotifier {
  final String token;
  MealsService({
    this.token,
    monthsMeals,
  }) {
    if (monthsMeals != null && monthsMeals.length > 0) {
      this.monthsMeals = monthsMeals;
      isLoaded = true;
    }
  }

  bool isLoaded = false;

  Map<String, DaysMeal> monthsMeals = {};

  List<MembersMeal> membersMeals(DateTime date) {
    return monthsMeals[DateFormat('yyyy-MM-dd').format(date)]?.membersMeals ??
        [];
  }

  Meal breakfast(DateTime date) {
    if (date == null) date = DateTime.now();
    return monthsMeals[DateFormat('yyyy-MM-dd').format(date)]?.breakfast ??
        Meal(type: 'breakfast', date: date);
  }

  Meal lunch(DateTime date) {
    if (date == null) date = DateTime.now();
    return monthsMeals[DateFormat('yyyy-MM-dd').format(date)]?.lunch ??
        Meal(type: 'lunch', date: date);
  }

  Meal dinner(DateTime date) {
    if (date == null) date = DateTime.now();
    return monthsMeals[DateFormat('yyyy-MM-dd').format(date)]?.dinner ??
        Meal(type: 'dinner', date: date);
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
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          Map<String, DaysMeal> tempMeals = {};
          result['data'].forEach((i, val) {
            tempMeals.putIfAbsent(i, () => DaysMeal.fromJson(val));
          });
          monthsMeals = tempMeals;
          notifyListeners();
        }
      } else {
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
      print(error);
      throw HttpException('Something went wrong, could not load meals!');
    }
  }

  bool toggleWholeMessBreakfast(DateTime dateTime) {
    bool shouldOff = false;
    membersMeals(dateTime).forEach((element) {
      if (element.breakfast) {
        shouldOff = true;
      }
    });
    membersMeals(dateTime).forEach((element) async {
      if ((shouldOff && element.breakfast) ||
          (!shouldOff && !element.breakfast)) {
        await element.toggleMeal('breakfast', token).catchError((_) {});
      }
    });
    notifyListeners();
    return !shouldOff;
  }

  bool toggleWholeMessLunch(DateTime dateTime) {
    bool shouldOff = false;
    membersMeals(dateTime).forEach((element) {
      if (element.lunch) {
        shouldOff = true;
      }
    });
    membersMeals(dateTime).forEach((element) async {
      if ((shouldOff && element.lunch) || (!shouldOff && !element.lunch)) {
        await element.toggleMeal('lunch', token).catchError((_) {});
      }
    });
    notifyListeners();
    return !shouldOff;
  }

  bool toggleWholeMessDinner(DateTime dateTime) {
    bool shouldOff = false;
    membersMeals(dateTime).forEach((element) {
      if (element.dinner) {
        shouldOff = true;
      }
    });
    membersMeals(dateTime).forEach((element) async {
      if ((shouldOff && element.dinner) || (!shouldOff && !element.dinner)) {
        await element.toggleMeal('dinner', token).catchError((_) {});
      }
    });
    notifyListeners();
    return !shouldOff;
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
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          if (!monthsMeals.containsKey(DateFormat('yyyy-MM-dd').format(date))) {
            // Jodi ei diner kono meal na thake tahole age initialize kore nitese
            monthsMeals[DateFormat('yyyy-MM-dd').format(date)] = new DaysMeal();
          }
          result['data'].forEach((item) {
            monthsMeals[DateFormat('yyyy-MM-dd').format(date)]
                .membersMeals
                .add(MembersMeal.fromJson(item));
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
