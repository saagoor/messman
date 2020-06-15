import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mess/constants.dart';
import 'package:mess/models/http_exception.dart';
import 'package:mess/models/meal.dart';
import 'package:mess/services/helpers.dart';
import 'package:http/http.dart' as http;

class MealsService with ChangeNotifier {
  final String token;
  MealsService({
    this.token,
    this.monthsMeals,
  }) {
    if (monthsMeals != null && monthsMeals.length > 0) {
      this.monthsMeals = monthsMeals;
      isLoaded = true;
    }
  }

  bool isLoaded = false;

  Map<DateTime, DaysMeal> monthsMeals = {};

  List<MembersMeal> membersMeals(DateTime date) {
    return monthsMeals[date].membersMeals;
  }

  Map<String, Meal> messMeals(DateTime date) {
    return monthsMeals[date].messMeals;
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
          print(result['data']);
        }
      } else {
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
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
          result['data'].forEach((item) {
            monthsMeals[date].membersMeals.add(MembersMeal.fromJson(item));
          });
          notifyListeners();
        } else {
          throw HttpException('Empty result returned from server!');
        }
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> setMenu(dateTime, String type, int foodId) async {}
}
