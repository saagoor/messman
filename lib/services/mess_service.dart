import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mess/constants.dart';
import 'package:mess/models/daily_meal.dart';
import 'package:mess/models/http_exception.dart';
import 'package:mess/models/models.dart';
import 'package:mess/models/task.dart';
import 'package:mess/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:mess/services/helpers.dart';

class MessService with ChangeNotifier {
  final AuthService auth;
  MessService({@required this.auth});

  bool isLoaded = false;
  Mess _mess;

  Mess get mess {
    return _mess;
  }

  List<Expense> expenses = [];
  List<Task> tasks = [];
  List<User> members = [];
  List<DailyMeal> dailyMeals = [];
  List<Deposit> deposits = [];

  Future<void> fetchAndSet() async {
    if (auth.user == null) {
      throw HttpException('You\'re not authenticated!');
    } else if (auth.user.messId == null) {
      return;
    }
    try {
      final response = await http.get(
        baseUrl + 'mess/${auth.user.messId}',
        headers: httpHeader(auth.token),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null || result['data'] != null){
          setAllData(result['data']);
          isLoaded = true;
          notifyListeners();
        }else{
          throw HttpException('Empty data received!');
        }
      } else {
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void setAllData(var data) {
    // Setting mess data
    _mess = Mess.fromJson(data['mess']);

    // Setting expenses data
    if (data['expenses'] != null) {
      List<Expense> tempExpenses = [];
      data['expenses'].forEach((item) {
        if (item != null) tempExpenses.add(Expense.fromJson(item));
      });
      expenses = tempExpenses;
    }

    // Setting tasks data
    if (data['tasks'] != null) {
      List<Task> tempTasks = [];
      data['tasks'].forEach((item) {
        if (item != null) tempTasks.add(Task.fromJson(item));
      });
      tasks = tempTasks;
    }

    // Setting members data
    if (data['members'] != null) {
      List<User> tempMembers = [];
      data['members'].forEach((item) {
        if (item != null) tempMembers.add(User.fromJson(item));
      });
      members = tempMembers;
    }

    // Setting daily meals data
    if (data['daily_meals'] != null) {
      List<DailyMeal> tempDailyMeals = [];
      data['daily_meals'].forEach((item) {
        if (item != null) tempDailyMeals.add(DailyMeal.fromJson(item));
      });
      dailyMeals = tempDailyMeals;
    }

    // Setting depositsdata
    if (data['deposits'] != null) {
      List<Deposit> tempDeposits = [];
      data['deposits'].forEach((item) {
        if (item != null) tempDeposits.add(Deposit.fromJson(item));
      });
      deposits = tempDeposits;
    }
  }

  Future<void> joinMess(String joinCode) async {
    try {
      final response = await http.post(
        baseUrl + 'mess/join',
        headers: httpHeader(auth.token),
        body: json.encode({'join_code': joinCode}),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          setAllData(result['data']);
          auth.messId = _mess.id;
          notifyListeners();
        } else {
          throw HttpException('Could not join mess!');
        }
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> createMess(Mess mess) async {
    try {
      final response = await http.post(
        baseUrl + 'mess',
        headers: httpHeader(auth.token),
        body: json.encode(mess.toJson()),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          _mess = Mess.fromJson(result['data']);
          if (_mess != null) {
            auth.messId = _mess.id;
            notifyListeners();
          }
        }
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }
}