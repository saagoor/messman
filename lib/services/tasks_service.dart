import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mess/constants.dart';
import 'package:mess/models/http_exception.dart';
import 'package:mess/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:mess/services/helpers.dart';

class TasksService with ChangeNotifier {
  final String token;
  TasksService({
    this.token,
    List<Task> prevItems,
  }) {
    if (prevItems != null && prevItems.length > 0) {
      this._items = prevItems;
      isLoaded = true;
    }
  }
  bool isLoaded = false;

  List<Task> _items = [];

  List<Task> get oldItems {
    return _items.where((element) {
      final now = DateTime.now();
      return element.dateTime.isBefore(now.subtract(Duration(days: 1)));
    }).toList();
  }

  List<Task> get items {
    return _items.where((element) {
      final now = DateTime.now();
      return element.dateTime.isAfter(now.subtract(Duration(days: 1)));
    }).toList();
  }

  set items(List<Task> newTasks){
    this._items = newTasks;
    isLoaded = true;
    notifyListeners();
  }

  List<Task> usersTasks({int userId}) {
    return items.where((element) => element.memberId == userId).toList();
  }

  List<Task> upcomingTasks({int userId}) {
    return usersTasks(userId: userId)
        .where((element) =>
            (element.dateTime.isBefore(DateTime.now().add(Duration(days: 7)))))
        .take(3)
        .toList();
  }

  Future<void> fetchAndSet() async {
    try {
      final response = await http.get(
        baseUrl + 'tasks',
        headers: httpHeader(token),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (result != null) {
          List<Task> tempTasks = [];
          result['data'].forEach((item) {
            if (item != null) {
              tempTasks.add(Task.fromJson(item));
            }
          });
          _items = tempTasks;
          isLoaded = true;
          notifyListeners();
        }
      } else {
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    } catch (error) {
      throw HttpException('Something went wrong, could not load tasks!');
    }
  }

  Future<void> addTask(Task task) async{
    try{
      final response = await http.post(
        baseUrl + 'tasks',
        headers: httpHeader(token),
        body: json.encode(task.toJson()),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        final result = json.decode(response.body) as Map<String, dynamic>;
        if(result != null && result['data'] != null){
          _items.add(Task.fromJson(result['data']));
          print(result);
          notifyListeners();
        }
      }else{
        return handleHttpErrors(response);
      }
    } on SocketException catch (_) {
      throw HttpException('Could not connect to the server!');
    }catch(error){
      throw HttpException('Something went wrong, could not add task to the server.');
    }
  }
}
