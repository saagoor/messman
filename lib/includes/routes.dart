import 'package:messman/screens/add_deposit_screen.dart';
import 'package:messman/screens/add_expense_screen.dart';
import 'package:messman/screens/auth/edit_profile_screen.dart';
import 'package:messman/screens/auth/forgot_password_screen.dart';
import 'package:messman/screens/auth/profile_screen.dart';
import 'package:messman/screens/auth/signin_screen.dart';
import 'package:messman/screens/auth/signup_screen.dart';
import 'package:messman/screens/chat/chat_screen.dart';
import 'package:messman/screens/close_month_screen.dart';
import 'package:messman/screens/deposits_screen.dart';
import 'package:messman/screens/meals/meals_screen.dart';
import 'package:messman/screens/meals/meals_table_view_screen.dart';
import 'package:messman/screens/meals/set_meal_screen.dart';
import 'package:messman/screens/members_screen.dart';
import 'package:messman/screens/mess/create_mess_screen.dart';
import 'package:messman/screens/save_member_screen.dart';
import 'package:messman/screens/save_task_screen.dart';
import 'package:messman/screens/settings/settings_screen.dart';

final messManRoutes = {
  SigninScreen.routeName: (ctx) => SigninScreen(),
  SignupScreen.routeName: (ctx) => SignupScreen(),
  ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
  CreateMessScreen.routeName: (ctx) => CreateMessScreen(),
  CloseMonthScreen.routeName: (ctx) => CloseMonthScreen(),
  SettingsScreen.routeName: (ctx) => SettingsScreen(),
  ProfileScreen.routeName: (ctx) => ProfileScreen(),
  EditProfileScreen.routeName: (ctx) => EditProfileScreen(),
  MembersScreen.routeName: (ctx) => MembersScreen(),
  SaveMemberScreen.routeName: (ctx) => SaveMemberScreen(),
  MealsScreen.routeName: (ctx) => MealsScreen(),
  MealsTableViewScreen.routeName: (ctx) => MealsTableViewScreen(),
  SetMealScreen.routeName: (ctx) => SetMealScreen(),
  SaveTaskScreen.routeName: (ctx) => SaveTaskScreen(),
  AddExpenseScreen.routeName: (ctx) => AddExpenseScreen(),
  DepositsScreen.routeName: (ctx) => DepositsScreen(),
  AddDepositScreen.routeName: (ctx) => AddDepositScreen(),
  ChatScreen.routeName: (ctx) => ChatScreen(),
};
