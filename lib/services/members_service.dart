import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:messman/constants.dart';
import 'package:messman/models/http_exception.dart';
import 'package:messman/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:messman/models/user.dart';
import 'package:messman/services/helpers.dart';

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

  set items(List<User> newMembers) {
    this._items = newMembers;
  }

  void addItem(User user) {
    _items.add(user);
    notifyListeners();
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

  Future<void> addMember(User user, File image) async {
    try {
      final Uri uri = Uri.parse(baseUrl + 'members');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(httpHeader(token, hasFile: true));
      request.fields['name'] = user.name;
      request.fields['email'] = user.email;
      request.fields['phone'] = user.phone;
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          addItem(User.fromJson(result['data']));
        }
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeMember(int memberId) async {
    try {
      final response = await http.delete(baseUrl + 'members/$memberId',
          headers: httpHeader(token));

      if (response.statusCode == 200) {
        _items.removeWhere((user) => user.id == memberId);
        notifyListeners();
        return;
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }

  User memberById(int userId) {
    return _items.firstWhere((element) => element.id == userId,
        orElse: () => User(name: 'MessMan Member'));
  }
}
