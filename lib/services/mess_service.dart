import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:messman/constants.dart';
import 'package:messman/models/deposit.dart';
import 'package:messman/models/expense.dart';
import 'package:messman/models/http_exception.dart';
import 'package:messman/models/meal.dart';
import 'package:messman/models/mess.dart';
import 'package:messman/models/task.dart';
import 'package:messman/models/user.dart';
import 'package:messman/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:messman/services/helpers.dart';

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
  Map<String, DaysMeal> monthsMeals = {};
  List<Deposit> deposits = [];

  Future<void> fetchAndSet() async {
    if (auth.user == null) {
      throw HttpException('You\'re not authenticated!');
    } else if (auth.user.messId == null) {
      throw HttpException('You haven\'t joined any Mess!');
    }
    try {
      final response = await http.get(
        baseUrl + 'mess/${auth.user.messId}',
        headers: httpHeader(auth.token),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null || result['data'] != null) {
          setAllData(result['data']);
          isLoaded = true;
          members.forEach((element) => print(element.name));
          notifyListeners();
        } else {
          throw HttpException(
            'Empty data received!',
            statusCode: response.statusCode,
          );
        }
      } else {
        if (response.statusCode == 404) {
          auth.messId = null;
        }
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
      throw error;
    }
  }

  void setAllData(var data) {
    // Setting mess data
    _mess = Mess.fromJson(data['mess']);

    // Updating user data
    if (data['user'] != null) {
      auth.user = User.fromJson(data['user']);
    }
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
    if (data['meals'] != null) {
      Map<String, DaysMeal> tempMeals = {};
      data['meals'].forEach((i, val) {
        tempMeals.putIfAbsent(i, () => DaysMeal.fromJson(val));
      });
      monthsMeals = tempMeals;
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

  Future<int> joinMess(String joinCode) async {
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
          notifyListeners();
          return _mess?.id;
        } else {
          throw HttpException('Could not join mess!');
        }
      } else {
        handleHttpErrors(response);
      }
      return null;
    } catch (error) {
      throw error;
    }
  }

  Future<int> createMess(Mess mess) async {
    try {
      final response = await http.post(
        baseUrl + 'mess',
        headers: httpHeader(auth.token),
        body: json.encode(mess.toJson()),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          setAllData(result['data']);
          return _mess?.id;
        }
      } else {
        handleHttpErrors(response);
      }
      return null;
    } catch (error) {
      throw error;
    }
  }

  Future<void> editMess(Mess mess) async {
    try {
      final response = await http.put(
        baseUrl + 'mess/${mess.id}',
        headers: httpHeader(auth.token),
        body: json.encode(mess.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          setAllData(result['data']);
          notifyListeners();
          return;
        }
      } else {
        handleHttpErrors(response);
      }
      return null;
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteMess(int messId) async {
    try {
      final response = await http.delete(
        baseUrl + 'mess/$messId',
        headers: httpHeader(auth.token),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result != null && result == 1) {
          _mess = null;
          auth.messId = null;
        }
      } else {
        handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> leaveMess() async {
    try {
      final response = await http.post(
        baseUrl + 'mess/leave',
        headers: httpHeader(auth.token),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result != null && result == 1) {
          _mess = null;
          auth.messId = null;
          return true;
        }
      } else {
        handleHttpErrors(response);
      }
      return false;
    } catch (error) {
      throw error;
    }
  }
}
