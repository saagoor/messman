import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mess/constants.dart';
import 'package:mess/models/daily_meal.dart';
import 'package:mess/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:mess/services/helpers.dart';

class MealsService with ChangeNotifier {
  final String token;
  MealsService({
    this.token,
    List<DailyMeal> prevItems,
  }) {
    if (prevItems != null && prevItems.length > 0) {
      this._dailyMeals = prevItems;
      isLoaded = true;
    }
  }
  bool isLoaded = false;

  List<DailyMeal> _dailyMeals = [];

  List<DailyMeal> get meals {
    return [..._dailyMeals];
  }

  set meals(List<DailyMeal> newMeals) {
    this._dailyMeals = newMeals;
    isLoaded = true;
    notifyListeners();
  }

  List<DailyMeal> mealsOfYear(DateTime dateTime) {
    return _dailyMeals
        .where((item) => (item.date.year == dateTime.year))
        .toList();
  }

  List<DailyMeal> mealsOfMonth(DateTime dateTime) {
    return mealsOfYear(dateTime)
        .where(
          (item) => (item.date.month == dateTime.month),
        )
        .toList();
  }

  List<DailyMeal> mealsOfDay(DateTime dateTime) {
    List<DailyMeal> daysMeals = mealsOfMonth(dateTime)
        .where((item) => (item.date.day == dateTime.day))
        .toList();
    daysMeals.sort((a, b) => a.memberId.compareTo(b.memberId));
    return daysMeals;
  }

  DailyMeal mealByUser(DateTime dateTime, int userId) {
    return mealsOfDay(dateTime).firstWhere(
      (item) => item.memberId == userId,
      orElse: () => DailyMeal(
        date: dateTime,
        breakfast: true,
        lunch: true,
        dinner: true,
      ),
    );
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
          List<DailyMeal> tempMeals = [];
          result['data'].forEach((item) {
            tempMeals.add(DailyMeal.fromJson(item));
          });
          meals = tempMeals;
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
    mealsOfDay(dateTime).forEach((element) {
      if (element.breakfast) {
        shouldOff = true;
      }
    });
    mealsOfDay(dateTime).forEach((element) async {
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
    mealsOfDay(dateTime).forEach((element) {
      if (element.lunch) {
        shouldOff = true;
      }
    });
    mealsOfDay(dateTime).forEach((element) async {
      if ((shouldOff && element.lunch) || (!shouldOff && !element.lunch)) {
        await element.toggleMeal('lunch', token).catchError((_) {});
      }
    });
    notifyListeners();
    return !shouldOff;
  }

  bool toggleWholeMessDinner(DateTime dateTime) {
    bool shouldOff = false;
    mealsOfDay(dateTime).forEach((element) {
      if (element.dinner) {
        shouldOff = true;
      }
    });
    mealsOfDay(dateTime).forEach((element) async {
      if ((shouldOff && element.dinner) || (!shouldOff && !element.dinner)) {
        await element.toggleMeal('dinner', token).catchError((_) {});
        print(element.toJson());
      }
    });
    notifyListeners();
    return !shouldOff;
  }

  Future<void> addGuestMeal(
      DateTime date, int memberId, double guestCount) async {
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
            _dailyMeals.add(DailyMeal.fromJson(item));
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

}
