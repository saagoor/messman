import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:messman/constants.dart';
import 'package:messman/models/food.dart';

import 'package:http/http.dart' as http;
import 'package:messman/models/http_exception.dart';
import 'package:messman/services/helpers.dart';

class FoodsService with ChangeNotifier {
  final String token;
  final List<Food> prevItems;
  FoodsService({this.token, this.prevItems}) {
    if (prevItems != null && prevItems.length > 0) {
      _items = prevItems;
      isLoaded = true;
    }
  }
  List<Food> _items = [];
  List<Food> get items {
    return [..._items];
  }

  List<Food> search(String queryString) {
    return _items
        .where((item) =>
            item.title.toLowerCase().contains(queryString.toLowerCase()))
        .toList();
  }

  bool isLoaded = false;

  Future<void> fetchAndSet() async {
    isLoaded = true;
    try {
      final response = await http.get(
        baseUrl + 'foods',
        headers: httpHeader(token),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          List<Food> tempFoods = [];
          result['data'].forEach((item) {
            tempFoods.add(Food.fromJson(item));
          });
          _items = tempFoods;
          notifyListeners();
        } else {
          throw HttpException('No food has been stored on the server!');
        }
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }
}
