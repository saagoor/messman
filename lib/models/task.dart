import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:messman/constants.dart';
import 'package:messman/models/http_exception.dart';
import 'package:messman/includes/helpers.dart';

part 'task.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Task with ChangeNotifier {
  int id;
  int memberId;
  int messId;
  String title;
  DateTime dateTime;
  @JsonKey(defaultValue: 'pending')
  String status;
  String instruction;
  @JsonKey(defaultValue: 0)
  int incompleteFine;

  Task({
    this.id,
    this.memberId,
    this.messId,
    this.title,
    this.dateTime,
    this.status = 'pending',
    this.instruction,
    this.incompleteFine = 0,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  bool shouldHighlight() {
    if (status == 'complete' || status == 'incomplete') {
      return false;
    }
    DateTime now = DateTime.now();
    if (dateTime.isBefore(now.add(Duration(hours: 6))) &&
        dateTime.isAfter(now.subtract(Duration(hours: 6)))) {
      return true;
    }
    return false;
  }

  Future<void> updateStatus(
      {@required String newStatus, @required String token}) async {
    final oldStatus = status;
    status = newStatus;
    notifyListeners();
    try {
      final response = await http.patch(
        baseUrl + 'tasks/$id/update-status',
        headers: httpHeader(token),
        body: json.encode({'status': newStatus}),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result == 1) {
          return;
        } else {
          status = oldStatus;
          notifyListeners();
        }
      } else {
        status = oldStatus;
        notifyListeners();
        return handleHttpErrors(response);
      }
    } catch (error) {
      status = oldStatus;
      notifyListeners();
      throw HttpException('Could not update task status!');
    }
  }
}
