import 'package:messman/screens/save_deposit_screen.dart';
import 'package:messman/screens/save_expense_screen.dart';
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
  SaveExpenseScreen.routeName: (ctx) => SaveExpenseScreen(),
  DepositsScreen.routeName: (ctx) => DepositsScreen(),
  SaveDepositScreen.routeName: (ctx) => SaveDepositScreen(),
  ChatScreen.routeName: (ctx) => ChatScreen(),
};
