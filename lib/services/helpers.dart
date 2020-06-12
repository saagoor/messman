import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mess/models/daily_meal.dart';
import 'package:mess/models/http_exception.dart';
import 'package:mess/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:mess/services/auth_service.dart';

int lastDayOfMonth(DateTime dateTime) {
  final now = dateTime ?? DateTime.now();
  return DateTime(now.year, now.month + 1, 0).day;
}

bool canOnOffMeal(User member, DailyMeal meal) {
  if (member == null || meal == null) {
    return false;
  }
  if ((member.id == meal.memberId) || member.isManager) {
    return true;
  }
  return false;
}

int weekNumber(DateTime dateTime) {
  // final monthsFirstDay = DateTime(dateTime.year, dateTime.month, 1);
  return (dateTime.day / 7).floor() + 1;
}

String getWeek(int day) {
  if (day < 7) {
    return '1st Week';
  } else if (day < 14) {
    return '2nd Week';
  } else if (day < 21) {
    return '3rd Week';
  } else if (day < 28) {
    return '4th Week';
  } else {
    return 'End of Month';
  }
}

List<String> expenseTypes = ['shopping', 'utility', 'party'];

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

void showHttpError(BuildContext context, error, {String title}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title ?? 'Oooops!'),
      content: Text(error.toString()),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (context != null) {
              Navigator.of(context).pop();
            }
          },
          child: Text('Okay'),
        ),
      ],
    ),
  );
}

void showHttpSnackbarError(BuildContext context, error) {
  if (context != null) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }
}

void handleHttpErrors(http.Response response, {Function logoutCallback}) async {
  final Map<String, dynamic> result = json.decode(response.body);
  if(response.statusCode == 404){
    throw HttpException('Error: 404! Unknown action.');
  }else if (response.statusCode == 401 &&
      result['message'].toString().contains('Unauthenticated')) {
    // Unauthenticated
    if (logoutCallback != null) {
      // await logoutCallback();
      await AuthService().logout();
    }
    throw HttpException(
        'Sorry you\'re not logged in. You need to be logged in for this action.');
  } else if (response.statusCode == 500) {
    throw HttpException(
        'Sorry, internal server error occured. Please try again later or contact the support.');
  }
  final errors = result['errors'] as Map<String, dynamic>;
  final errorMsgs = errors?.values?.toList();
  if (errorMsgs == null) {
    if (result['success'] == false) {
      throw HttpException(result['message']);
    }
    return;
  }
  String finalMsg = '';
  errorMsgs.forEach((element) {
    if (finalMsg.isNotEmpty) {
      finalMsg += ' ';
    }
    return finalMsg += element[0];
  });
  throw HttpException(finalMsg);
}

httpHeader(String token) => {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };