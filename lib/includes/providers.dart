import 'package:messman/services/auth_service.dart';
import 'package:messman/services/deposits_service.dart';
import 'package:messman/services/expenses_service.dart';
import 'package:messman/services/foods_service.dart';
import 'package:messman/services/meals_service.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:messman/services/settings_service.dart';
import 'package:messman/services/tasks_service.dart';
import 'package:provider/provider.dart';

var messManProviders = [
  ChangeNotifierProvider.value(value: AuthService()),
  ChangeNotifierProxyProvider<AuthService, MessService>(
    create: (ctx) => MessService(auth: null),
    update: (ctx, auth, prev) => MessService(auth: auth, prev: prev),
  ),
  ChangeNotifierProxyProvider2<AuthService, MessService, MembersService>(
    create: (ctx) => MembersService(),
    update: (ctx, auth, messData, prev) {
      return MembersService(
        token: auth.token,
        prevItems: messData.members,
      );
    },
  ),
  ChangeNotifierProxyProvider2<AuthService, MessService, ExpensesService>(
    create: (ctx) => ExpensesService(),
    update: (ctx, auth, messData, prev) {
      final prevItems = prev.isLoaded || prev.items.length > 0
          ? prev.items
          : messData.expenses;
      return ExpensesService(token: auth.token, prevItems: prevItems);
    },
  ),
  ChangeNotifierProxyProvider2<AuthService, MessService, TasksService>(
    create: (ctx) => TasksService(),
    update: (ctx, auth, messData, prev) {
      final prevItems =
          prev.isLoaded || prev.items.length > 0 ? prev.items : messData.tasks;
      return TasksService(token: auth.token, prevItems: prevItems);
    },
  ),
  ChangeNotifierProxyProvider2<AuthService, MessService, MealsService>(
    create: (ctx) => MealsService(),
    update: (ctx, auth, messData, prev) {
      return MealsService(
        token: auth.token,
        monthsMeals: messData.monthsMeals,
      );
    },
  ),
  ChangeNotifierProxyProvider3<AuthService, MessService, ExpensesService,
      DepositsService>(
    create: (ctx) => DepositsService(),
    update: (ctx, auth, messData, expenseData, prev) {
      return DepositsService(
        token: auth.token,
        prevItems: messData.deposits,
        depositedExpenses: expenseData.depositedItems,
      );
    },
  ),
  ChangeNotifierProxyProvider<AuthService, FoodsService>(
    create: (ctx) => FoodsService(),
    update: (ctx, auth, prev) =>
        FoodsService(token: auth.token, prevItems: prev.items),
  ),
  ChangeNotifierProvider.value(value: SettingsService()),
];
