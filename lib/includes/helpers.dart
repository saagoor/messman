import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:messman/models/http_exception.dart';
import 'package:messman/models/meal.dart';
import 'package:http/http.dart' as http;
import 'package:messman/models/user.dart';
import 'package:messman/services/auth_service.dart';
import 'package:provider/provider.dart';

int lastDayOfMonth(DateTime dateTime) {
  dateTime = dateTime ?? DateTime.now();
  return DateTime(dateTime.year, dateTime.month + 1, 0).day;
}

bool canOnOffMeal(User member, MembersMeal meal) {
  print(DateTime.now());
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

bool isCurrentMonthExpiring(DateTime currentMonth) {
  final now = DateTime.now();
  return currentMonth.isBefore(DateTime(now.year, now.month, 0)) ||
      now.isAfter(DateTime(currentMonth.year, currentMonth.month,
          (lastDayOfMonth(currentMonth) - 2)));
}

bool isCurrentMonthExpired(DateTime currentMonth) {
  final now = DateTime.now();
  return currentMonth.isBefore(DateTime(now.year, now.month, 0));
}

void showHttpError(BuildContext context, error, {String title}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
  ).then((_) async {
    if (error is HttpException && error.statusCode == 401 && context != null) {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.logout();
      print('Unauthenticated user logged out.');
      return Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (route) => false);
    }
  });
}

void showHttpSnackbarError(BuildContext context, Exception error) {
  if (context != null) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }
}

void handleHttpErrors(http.Response response) {
  final Map<String, dynamic> result = json.decode(response.body);
  if (response.statusCode == 404) {
    print(result);
    throw HttpException(
      'Error: 404! ' + result['message'] ?? '',
      statusCode: response.statusCode,
    );
  } else if (response.statusCode == 401 &&
      result['message'].toString().contains('Unauthenticated')) {
    throw HttpException(
      'Sorry you\'re not logged in. You need to be logged in for this action.',
      statusCode: response.statusCode,
    );
  } else if (response.statusCode == 500) {
    print('Error ${response.statusCode}: ' + response.body);
    throw HttpException(
      result['message'] ??
          'Sorry, internal server error occured. Please try again later or contact the support.',
      statusCode: response.statusCode,
    );
  } else if (response.statusCode != null && result['errors'] == null) {
    print('Error ${response.statusCode}: ' + response.body);
    throw HttpException(
      result['message'] ??
          'Sorry, something went wrong. Could not complete the action',
      statusCode: response.statusCode,
    );
  }
  final errors = result['errors'] as Map<String, dynamic>;
  final errorMsgs = errors?.values?.toList();
  if (errorMsgs == null) {
    if (result['success'] == false) {
      throw HttpException(
        result['message'],
        statusCode: response.statusCode,
      );
    }
    return;
  }
  String finalMsg = '';
  errorMsgs.forEach((element) {
    if (finalMsg.isNotEmpty) {
      finalMsg += ' \n'; // Adds line break for multiple error.
    }
    return finalMsg += element[0];
  });
  print(errors);
  throw HttpException(
    finalMsg,
    statusCode: response.statusCode,
  );
}

Map<String, String> httpHeader(String token, {bool hasFile = false}) => {
      'Content-Type': !hasFile ? 'application/json' : 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

String smartCount(double count) {
  final String roundedAmount = (count == null || count == 0 || count.isNaN)
      ? '0.0'
      : count.toStringAsFixed(2);
  final String amountStr = roundedAmount.split('.')[0];
  final String amountFraction = count.truncateToDouble() == count
      ? ''
      : '.' + roundedAmount.split('.')[1];
  if (amountFraction.isEmpty) {
    return amountStr;
  }
  return count.toStringAsFixed(1);
}
