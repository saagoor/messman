import 'package:flutter/widgets.dart';
import 'package:mess/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService with ChangeNotifier {
  final AuthService auth;
  SettingsService({this.auth});

  Future<SharedPreferences> prefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<bool> isAppTourComplete() async{
    final _prefs = await prefs();
    return _prefs.getBool('appTourComplete') ?? false;
  }

  Future<bool> completeAppTour() async{
    final _prefs = await prefs();
    return _prefs.setBool('appTourComplete', true).whenComplete((){
      notifyListeners();
    });
  }
}
