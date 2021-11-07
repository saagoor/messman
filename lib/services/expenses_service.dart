import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:messman/constants.dart';
import 'package:messman/models/expense.dart';
import 'package:http/http.dart' as http;
import 'package:messman/includes/helpers.dart';

class ExpensesService with ChangeNotifier {
  final String token;
  ExpensesService({
    this.token,
    List<Expense> prevItems,
  }) {
    if (prevItems != null && prevItems.length > 0) {
      _items = prevItems;
      isLoaded = true;
    }
  }

  bool isLoaded = false;

  List<Expense> _items = [];

  List<Expense> get items {
    return [..._items];
  }

  List<Expense> get depositedItems {
    return this.items.where((element) => element.fromSelfPocket).toList();
  }

  set items(List<Expense> newItems) {
    this._items = newItems;
    isLoaded = true;
    notifyListeners();
  }

  void reset({reload = false}) {
    this._items = [];
    this.isLoaded = false;
    if (reload) {
      notifyListeners();
    }
  }

  List<Expense> expensesByUser(int userId) {
    return _items.where((element) => element.memberId == userId).toList();
  }

  Future<void> fetchAndSet() async {
    print('fetching expenses');
    isLoaded = true;
    try {
      final response = await http.get(
        baseUrl + 'expenses',
        headers: httpHeader(token),
      );
      if (response.statusCode == 200) {
        List<Expense> tempExpenses = [];
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          result['data'].forEach((e) {
            tempExpenses.add(Expense.fromJson(e));
          });
          items = tempExpenses;
        } else {
          return handleHttpErrors(response);
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> saveExpense(Expense expense) {
    if (expense.id != null) {
      return this.editExpense(expense);
    }
    return this.addExpense(expense);
  }

  Future<void> editExpense(Expense expense) async {
    try {
      final response = await http.put(
        baseUrl + 'expenses/${expense.id}',
        headers: httpHeader(token),
        body: json.encode(expense),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          _items[_items.indexWhere((element) => element.id == expense.id)] =
              Expense.fromJson(result['data']);
          notifyListeners();
        }
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final response = await http.post(
        baseUrl + 'expenses',
        headers: httpHeader(token),
        body: json.encode(expense),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          _items.insert(0, Expense.fromJson(result['data']));
          notifyListeners();
        }
      } else {
        return handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> delete(int id) async {
    _items.removeWhere((element) => element.id == id);
    try {
      final response = await http.delete(baseUrl + 'expenses/$id',
          headers: httpHeader(token));
      if (response.statusCode == 200) {
        if (json.decode(response.body) == 1) {
          notifyListeners();
          return true;
        }
      } else {
        handleHttpErrors(response);
      }
    } catch (error) {
      throw error;
    }
    return false;
  }

  List<Expense> get shoppings {
    return _items.where((element) => element.type == 'shopping').toList();
  }

  List<Expense> get utilities {
    return _items.where((element) => element.type == 'utility').toList();
  }

  int get shoppingsTotal {
    return shoppings.fold(0, (prevVal, element) => prevVal + element.amount);
  }

  int get utilitiesTotal {
    return utilities.fold(0, (prevVal, element) => prevVal + element.amount);
  }

  int get total {
    return _items.fold(0, (prevVal, element) => prevVal + element.amount);
  }
}
