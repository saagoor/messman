import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messman/constants.dart';
import 'package:messman/models/http_exception.dart';
import 'package:messman/models/user.dart';
import 'package:messman/includes/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  User _user;
  Timer _authTimer;

  bool get isLoggedIn {
    return token != null;
  }

  String get token {
    if ((_expiryDate != null) &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  User get user {
    return _user;
  }

  set user(User user) {
    this._user = user;
    _setAuthPrefs();
    notifyListeners();
  }

  set messId(int messId) {
    this._user.messId = messId;
    _setAuthPrefs();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _user = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.remove('user');
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await http.post(
        baseUrl + 'login',
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: httpHeader(_token),
      );

      if (response.statusCode == 200) {
        return _handleAuth(response);
      } else {
        return _handleErrors(response);
      }
    } catch (error) {
      print(error);
      throw HttpException(error.toString());
    }
  }

  Future<void> signUp(Map<String, String> authData) async {
    try {
      final response = await http.post(
        baseUrl + 'register',
        headers: httpHeader(_token),
        body: json.encode(authData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return _handleAuth(response);
      } else {
        return _handleErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> facebookSignIn() async {}

  Future<void> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print(googleAuth);
    } on PlatformException catch (error) {
      print(error);
      throw HttpException(getReadableMessage(error.code));
    } catch (error) {
      throw HttpException(
          'Sign in failed! Could not sign you in. Please try again later.');
    }
  }

  void _handleErrors(http.Response response) async {
    return handleHttpErrors(response);
  }

  void _handleAuth(http.Response response) {
    final result = json.decode(response.body);
    final data = result['data'];
    final bool succeed = data['success'] ?? false;
    if (succeed) {
      _token = data['token']['access_token'];
      _expiryDate = DateTime.parse(data['token']['expires_at']);
      _user = User.fromJson(data['user']);
      _autoLogout();
      notifyListeners();
      _setAuthPrefs();
    }
  }

  void _setAuthPrefs() async {
    final authPrefs = await SharedPreferences.getInstance();
    final authData = json.encode({
      'token': _token,
      'expiryDate': _expiryDate.toIso8601String(),
    });
    authPrefs.setString('authData', authData);
    if (_user != null) {
      authPrefs.setString('user', json.encode(_user.toJson()));
    }
  }

  Future<bool> tryAutoLogin() async {
    final userPrefs = await SharedPreferences.getInstance();
    if (!userPrefs.containsKey('authData') || !userPrefs.containsKey('user')) {
      return false;
    }
    final extractedAuthData = json.decode(userPrefs.getString('authData'));

    final expiryDate = DateTime.parse(extractedAuthData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedAuthData['token'];
    _user = User.fromJson(json.decode(userPrefs.getString('user')));

    if (_token == null || _user == null) {
      return false;
    }
    _expiryDate = expiryDate;
    _autoLogout();
    print('Auto loging in');
    notifyListeners();
    return true;
  }

  String getReadableMessage(String code) {
    return code;
  }

  Future<void> editProfile(User user, File image) async {
    try {
      final Uri uri = Uri.parse(baseUrl + 'profile/edit');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(httpHeader(token, hasFile: true));
      request.fields['name'] = user.name;
      request.fields['email'] = user.email;
      request.fields['phone'] = user.phone;
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          this.user = User.fromJson(result['data']);
        } else {
          throw HttpException(
              'Something went wrong, could not update your profile.');
        }
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }
}
