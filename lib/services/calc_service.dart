import 'package:flutter/widgets.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/deposits_service.dart';
import 'package:messman/services/expenses_service.dart';
import 'package:messman/services/meals_service.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:provider/provider.dart';

class CalcService with ChangeNotifier {
  final BuildContext context;
  CalcService(this.context);

  AuthService get auth {
    return Provider.of<AuthService>(context);
  }

  MessService get messServ {
    return Provider.of<MessService>(context);
  }

  ExpensesService get expen {
    return Provider.of<ExpensesService>(context);
  }

  DepositsService get depo {
    return Provider.of<DepositsService>(context);
  }

  MembersService get memb {
    return Provider.of<MembersService>(context);
  }

  MealsService get mealsServ {
    return Provider.of<MealsService>(context);
  }

  double get breakfastSize {
    return messServ.mess?.breakfastSize ?? 1;
  }

  // int get userId {
  //   return auth.user.id ?? 0;
  // }

  double get mealsCount {
    return mealsServ.membersMealsOfMonth
        .where((element) => element.date.isBefore(DateTime.now()))
        .fold(0, (prevValue, element) {
      if (element.breakfast) prevValue += breakfastSize;
      if (element.lunch) prevValue++;
      if (element.dinner) prevValue++;
      return prevValue;
    });
  }

  double mealsCountOfUser(int userId) {
    double count = mealsServ.membersMealsOfMonth
        .where((element) =>
            element.memberId == userId && element.date.isBefore(DateTime.now()))
        .fold(0, (prevValue, element) {
      if (element.breakfast) prevValue += breakfastSize;
      if (element.lunch) prevValue++;
      if (element.dinner) prevValue++;
      return prevValue;
    });
    if (count == null || count == 0 || count.isNaN) {
      return 0;
    }
    return count;
  }

  double mealsCountOfPeriod(DateTime dateTime, String period) {
    if (dateTime == null) dateTime = DateTime.now();
    return mealsServ.membersMealsOfMonth
        .where((element) =>
            element.date.year == dateTime.year &&
            element.date.month == dateTime.month &&
            element.date.day == dateTime.day)
        .fold(0, (prevValue, element) {
      switch (period) {
        case 'breakfast':
          if (element.breakfast) prevValue += breakfastSize;
          break;
        case 'lunch':
          if (element.lunch) prevValue++;
          break;
        case 'dinner':
          if (element.dinner) prevValue++;
          break;
      }
      return prevValue;
    });
  }

  double get depositTotal {
    return depo.items.fold(0, (prevVal, element) => prevVal + element.amount);
  }

  double depositTotalOfUser(int userId) {
    return depo
        .depositsByUser(userId)
        .fold(0, (previousValue, element) => previousValue + element.amount);
  }

  double get utilsAvg {
    return expen.utilitiesTotal / memb.items.length;
  }

  double get expenseTotal {
    return expen.items
        .fold(0, (previousValue, element) => previousValue + element.amount);
  }

  double get shoppingExpenseTotal {
    return expen.shoppings
        .fold(0, (previousValue, element) => previousValue + element.amount);
  }

  double get utilityExpenseTotal {
    return expen.utilities
        .fold(0, (previousValue, element) => previousValue + element.amount);
  }

  double expenseTotalOfUser(int userId) {
    return (mealRate * mealsCountOfUser(userId)) + utilsAvg;
  }

  double get mealRate {
    return expen.shoppingsTotal / mealsCount;
  }

  double get balance {
    return depositTotal - expen.total;
  }

  double balanceOfUser(int userId) {
    return depositTotalOfUser(userId) - expenseTotalOfUser(userId);
  }
}
