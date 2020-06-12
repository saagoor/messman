import 'package:flutter/material.dart';
import 'package:mess/screens/auth/app_tour_screen.dart';
import 'package:mess/screens/auth/signin_screen.dart';
import 'package:mess/screens/auth/splash_screen.dart';
import 'package:mess/screens/home_screen.dart';
import 'package:mess/screens/mess/join_mess_screen.dart';
import 'package:mess/services/auth_service.dart';
import 'package:mess/services/settings_service.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    if (auth.isLoggedIn) {
      if (auth.user.messId == null) {
        return JoinMessScreen();
      }
      return HomeScreen();
    }
    return FutureBuilder<bool>(
      // Auth checking
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return SplashScreen();
        } else if (snapshot.data == true) {
          return HomeScreen();
        } else {
          final settings = Provider.of<SettingsService>(context);
          return FutureBuilder(
            future: settings.isAppTourComplete(),
            builder: (ctx, snap2) {
              if (snap2.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              } else if (!snap2.data) {
                return AppTourScreen();
              }
              return SigninScreen();
            },
          );
        }
      },
    );
  }
}
