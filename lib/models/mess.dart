import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:messman/includes/dialogs.dart';
import 'package:messman/services/deposits_service.dart';
import 'package:messman/services/expenses_service.dart';
import 'package:messman/services/meals_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:messman/services/tasks_service.dart';
import 'package:provider/provider.dart';
part 'mess.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Mess {
  int id;
  String name;
  String location;
  String joinCode;
  bool allowJoin;
  double breakfastSize;
  String currencySymbol;
  DateTime currentMonth;
  int createdBy;
  DateTime createdAt;

  Mess({
    this.id,
    this.name,
    this.location,
    this.joinCode,
    this.allowJoin,
    this.breakfastSize = 0.5,
    this.currencySymbol = '৳',
    this.currentMonth,
    this.createdBy,
    this.createdAt,
  });

  factory Mess.fromJson(Map<String, dynamic> json) => _$MessFromJson(json);
  Map<String, dynamic> toJson() => _$MessToJson(this);

  void closeMonth(BuildContext context) async {
    final messService = Provider.of<MessService>(context, listen: false);
    final isClosed = await showConfirmationDialog(
      context: context,
      deleteMethod: () => messService.closeMonth(),
      title: 'Closing Current Month!',
      confirmBtnText: 'Close Month',
      content:
          'Are you sure you want to close this month? This action will delete all the expense, deposits, tasks and meals data and start a fresh new month.',
      successMessage: 'Started a fresh new month!',
    );
    if (isClosed != null && isClosed) {
      messService.reset();
      Provider.of<ExpensesService>(context, listen: false).reset();
      Provider.of<DepositsService>(context, listen: false).reset();
      Provider.of<MealsService>(context, listen: false).reset();
      Provider.of<TasksService>(context, listen: false).reset();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }
}
