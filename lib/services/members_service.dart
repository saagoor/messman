import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mess/constants.dart';
import 'package:mess/models/http_exception.dart';
import 'package:mess/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:mess/services/helpers.dart';

class MembersService with ChangeNotifier {
  final String token;
  MembersService({
    this.token,
    List<User> prevItems,
  }) {
    if (prevItems != null && prevItems.length > 0) {
      this._items = prevItems;
    }
  }
  bool isLoaded = false;

  List<User> _items = [];

  List<User> get items {
    return [..._items];
  }
  set items(List<User> newMembers){
    this._items = newMembers;
  }

  Future<void> fetchAndSet() async {
    isLoaded = true;
    try {
      final response = await http.get(
        baseUrl + 'members',
        headers: httpHeader(token),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null) {
          final data = result['data'];
          List<User> tmpMembers = [];
          data.forEach((e) {
            tmpMembers.add(User.fromJson(e));
          });
          _items = tmpMembers;
          notifyListeners();
        }
      } else {
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
      throw HttpException('Something went wrong, could not load members.');
    }
  }

  Future<void> addMember(User user) async {
    _items.add(user);
    notifyListeners();
  }

  User memberById(int userId) {
    return _items.firstWhere((element) => element.id == userId,
        orElse: () => User(name: 'MessMan Member'));
  }
}
