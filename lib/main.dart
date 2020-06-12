import 'package:flutter/material.dart';
import 'package:mess/screens/add_deposit_screen.dart';
import 'package:mess/screens/add_expense_screen.dart';
import 'package:mess/screens/auth/forgot_password_screen.dart';
import 'package:mess/screens/auth/profile_screen.dart';
import 'package:mess/screens/auth/signin_screen.dart';
import 'package:mess/screens/auth/signup_screen.dart';
import 'package:mess/screens/close_month_screen.dart';
import 'package:mess/screens/deposits_screen.dart';
import 'package:mess/screens/meals/meals_screen.dart';
import 'package:mess/screens/meals/meals_table_view_screen.dart';
import 'package:mess/screens/meals/set_meal_screen.dart';
import 'package:mess/screens/members_screen.dart';
import 'package:mess/screens/mess/create_mess_screen.dart';
import 'package:mess/screens/save_member_screen.dart';
import 'package:mess/screens/save_task_screen.dart';
import 'package:mess/screens/settings_screen.dart';
import 'package:mess/screens/wrapper.dart';
import 'package:mess/services/auth_service.dart';
import 'package:mess/services/deposits_service.dart';
import 'package:mess/services/expenses_service.dart';
import 'package:mess/services/food_service.dart';
import 'package:mess/services/meals_service.dart';
import 'package:mess/services/members_service.dart';
import 'package:mess/services/mess_service.dart';
import 'package:mess/services/settings_service.dart';
import 'package:mess/services/tasks_service.dart';
import 'package:provider/provider.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider.value(value: AuthService()),
        ChangeNotifierProxyProvider<AuthService, MessService>(
          create: (ctx) => MessService(auth: null),
          update: (ctx, auth, prev) => MessService(auth: auth),
        ),
        ChangeNotifierProxyProvider2<AuthService, MessService, MembersService>(
          create: (ctx) => MembersService(),
          update: (ctx, auth, messData, prev){
            final prevItems = prev.isLoaded || prev.items.length > 0 ? prev.items : messData.members;
            return MembersService(token: auth.token, prevItems: prevItems);
          },
        ),
        ChangeNotifierProxyProvider2<AuthService, MessService, ExpensesService>(
          create: (ctx) => ExpensesService(),
          update: (ctx, auth, messData, prev){
            final prevItems = prev.isLoaded || prev.items.length > 0 ? prev.items : messData.expenses;
            return ExpensesService(token: auth.token, prevItems: prevItems);
          },
        ),
        ChangeNotifierProxyProvider2<AuthService, MessService, TasksService>(
          create: (ctx) => TasksService(),
          update: (ctx, auth, messData, prev){
            final prevItems = prev.isLoaded || prev.items.length > 0 ? prev.items : messData.tasks;
            return TasksService(token: auth.token, prevItems: prevItems);
          },
        ),
        ChangeNotifierProxyProvider2<AuthService, MessService, MealsService>(
          create: (ctx) => MealsService(),
          update: (ctx, auth, messData, prev){
            final prevItems = prev.isLoaded || prev.meals.length > 0 ? prev.meals : messData.dailyMeals;
            return MealsService(token: auth.token, prevItems: prevItems);
          },
        ),
        ChangeNotifierProxyProvider2<AuthService, MessService, DepositsService>(
          create: (ctx) => DepositsService(),
          update: (ctx, auth, messData, prev){
            final prevItems = prev.isLoaded || prev.items.length > 0 ? prev.items : messData.deposits;
            return DepositsService(token: auth.token, prevItems: prevItems);
          },
        ),
        ChangeNotifierProvider.value(value: DailyFoodsService()),
        ChangeNotifierProvider.value(value: SettingsService()),
      ],
      child: MessApp(),
    );
  }
}

class MessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'ProductSans',
        primarySwatch: Colors.lightBlue,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          headline2: TextStyle(fontSize: 22),
          headline3: TextStyle(fontSize: 18),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.2)
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'MessMan',
      home: Wrapper(),
      routes: {
        SigninScreen.routeName: (ctx) => SigninScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
        ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
        CreateMessScreen.routeName: (ctx) => CreateMessScreen(),
        CloseMonthScreen.routeName: (ctx) => CloseMonthScreen(),
        SettingsScreen.routeName: (ctx) => SettingsScreen(),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
        MembersScreen.routeName: (ctx) => MembersScreen(),
        SaveMemberScreen.routeName: (ctx) => SaveMemberScreen(),
        MealsScreen.routeName: (ctx) => MealsScreen(),
        MealsTableViewScreen.routeName: (ctx) => MealsTableViewScreen(),
        SetMealScreen.routeName: (ctx) => SetMealScreen(),
        SaveTaskScreen.routeName: (ctx) => SaveTaskScreen(),
        AddExpenseScreen.routeName: (ctx) => AddExpenseScreen(),
        DepositsScreen.routeName: (ctx) => DepositsScreen(),
        AddDepositScreen.routeName: (ctx) => AddDepositScreen(),
      },
    );
  }
}
