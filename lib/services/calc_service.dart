import 'package:flutter/widgets.dart';
import 'package:mess/services/auth_service.dart';
import 'package:mess/services/deposits_service.dart';
import 'package:mess/services/expenses_service.dart';
import 'package:mess/services/meals_service.dart';
import 'package:mess/services/members_service.dart';
import 'package:mess/services/mess_service.dart';
import 'package:provider/provider.dart';

class CalcService with ChangeNotifier{
  final BuildContext context;
  CalcService(this.context);

  AuthService get auth{
    return Provider.of<AuthService>(context);
  }
  MessService get messServ{
    return Provider.of<MessService>(context);
  }
  ExpensesService get expen{
    return Provider.of<ExpensesService>(context);
  }
  DepositsService get depo{
    return Provider.of<DepositsService>(context);
  }
  MembersService get memb{
    return Provider.of<MembersService>(context);
  }
  MealsService get mealsServ{
    return Provider.of<MealsService>(context);
  }


  double get breakfastSize{
    return messServ.mess?.breakfastSize ?? 1;
  }

  int get userId{
    return auth.user.id ?? 0;
  }


  double get mealsCount{
    return mealsServ.meals
        .where((element) => element.date.isBefore(DateTime.now()))
        .fold(0, (prevValue, element) {
      if (element.breakfast) prevValue += breakfastSize;
      if (element.lunch) prevValue++;
      if (element.dinner) prevValue++;
      return prevValue;
    });
  }

  double get mealsCountOfUser{
    return mealsServ.meals
        .where((element) => element.memberId == userId && element.date.isBefore(DateTime.now()))
        .fold(0, (prevValue, element) {
      if (element.breakfast) prevValue += breakfastSize;
      if (element.lunch) prevValue++;
      if (element.dinner) prevValue++;
      return prevValue;
    });
  }

  double get depositTotal{
    return depo.items.fold(0, (prevVal, element) => prevVal + element.amount);
  }

  double get depositTotalOfUser{
    return depo.depositsByUser(userId).fold(0, (previousValue, element) => previousValue + element.amount);
  }

  double get utilsAvg{
    return expen.utilitiesTotal / memb.items.length;
  }

  double get expenseTotal{
    return expen.items.fold(0, (previousValue, element) => previousValue + element.amount);
  }

  double get expenseTotalOfUser{
    return (mealRate * mealsCountOfUser) + utilsAvg;
  }

  double get mealRate{
    return expen.shoppingsTotal / mealsCount;
  }

  double get balance{
    return depositTotal - expen.total;
  }

  double get balanceOfUser{
    return depositTotalOfUser - expenseTotalOfUser;
  }

}