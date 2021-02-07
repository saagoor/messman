import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:messman/constants.dart';
import 'package:messman/models/deposit.dart';
import 'package:messman/models/expense.dart';
import 'package:messman/models/transaction.dart';
import 'package:messman/services/helpers.dart';
import 'package:http/http.dart' as http;

class DepositsService with ChangeNotifier {
  final String token;
  DepositsService({
    this.token,
    List<Deposit> prevItems,
    this.depositedExpenses,
  }) {
    if (prevItems != null && prevItems.length > 0) {
      _items = prevItems;
      isLoaded = true;
    }
  }

  bool isLoaded = false;
  List<Expense> depositedExpenses = [];
  List<Deposit> _items = [];

  List<Transaction> get items {
    if (depositedExpenses != null && depositedExpenses.length > 0)
      return [..._items, ...depositedExpenses];
    return [..._items];
  }

  set items(List<Deposit> newItems) {
    this._items = newItems;
    isLoaded = true;
    notifyListeners();
  }

  List<Transaction> depositsByUser(int userId) {
    return this.items.where((element) => element.memberId == userId).toList();
  }

  Future<void> fetchAndSet() async {
    print('fetching deposits');
    isLoaded = true;
    try {
      final response = await http.get(
        baseUrl + 'deposits',
        headers: httpHeader(token),
      );

      if (response.statusCode == 200) {
        List<Deposit> tempDeposits = [];
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          result['data'].forEach((e) {
            tempDeposits.add(Deposit.fromJson(e));
          });
          items = tempDeposits;
        } else {
          return handleHttpErrors(response);
        }
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
      throw HttpException('Something went wrong, could not load deposits!');
    }
  }

  Future<void> addDeposit(Deposit deposit) async {
    try {
      final response = await http.post(
        baseUrl + 'deposits',
        headers: httpHeader(token),
        body: json.encode(deposit),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null && result['data'] != null) {
          _items.insert(0, Deposit.fromJson(result['data']));
          notifyListeners();
        }
      } else {
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
      throw HttpException('Something went wrong, Could not add deposit!');
    }
  }

  Future<bool> delete(int id) async {
    _items.removeWhere((element) => element.id == id);
    try {
      final response = await http.delete(baseUrl + 'deposits/$id',
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
      throw HttpException('Could not delete deposit!');
    }
    return false;
  }
}
