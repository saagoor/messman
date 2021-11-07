import 'package:flutter/material.dart';
import 'package:messman/models/task.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/services/tasks_service.dart';
import 'package:messman/widgets/input_date_picker.dart';
import 'package:messman/widgets/input_time_picker.dart';
import 'package:messman/widgets/screen_loading.dart';
import 'package:messman/widgets/user/member_selector.dart';
import 'package:provider/provider.dart';

class SaveTaskScreen extends StatefulWidget {
  static const routeName = '/tasks/save';

  @override
  _SaveTaskScreenState createState() => _SaveTaskScreenState();
}

class _SaveTaskScreenState extends State<SaveTaskScreen> {
  final _form = GlobalKey<FormState>();
  final _instructionFocusNode = FocusNode();

  bool _isLoading = false;

  Task task = Task(
    title: '',
    instruction: '',
    dateTime: DateTime.now(),
  );
  TimeOfDay tasksTime;

  void _saveTask() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();

    setState(() {
      _isLoading = true;
    });

    await Provider.of<TasksService>(context, listen: false)
        .addTask(task)
        .then((value) {
      return Navigator.of(context).pop(true);
    }).catchError((error) => showHttpError(context, error));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    tasksTime = TimeOfDay.fromDateTime(task.dateTime ?? DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: <Widget>[
                MemberSelector(
                  initialId: task.memberId,
                  onChanged: (int selectedId) {
                    task.memberId = selectedId;
                  },
                ),
                SizedBox(height: 20),
                InputDatePicker(
                  value: task.dateTime,
                  firstDate: DateTime(task.dateTime.year, task.dateTime.month),
                  lastDate: DateTime(task.dateTime.year, task.dateTime.month,
                      lastDayOfMonth(task.dateTime)),
                  onSelect: (DateTime val) {
                    task.dateTime = val;
                  },
                ),
                SizedBox(height: 20),
                InputTimePicker(
                  initialTime: tasksTime,
                  onSelect: (TimeOfDay val) {
                    setState(() {
                      task.dateTime = DateTime(
                        task.dateTime.year,
                        task.dateTime.month,
                        task.dateTime.day,
                        val.hour,
                        val.minute,
                      );
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: task.title,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title),
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (val) {
                    FocusScope.of(context).requestFocus(_instructionFocusNode);
                  },
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Title cannot be empty!';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    task.title = val;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: task.instruction,
                  decoration: InputDecoration(
                    labelText: 'Instruction',
                    prefixIcon: Icon(Icons.directions),
                  ),
                  focusNode: _instructionFocusNode,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  onSaved: (val) {
                    task.instruction = val;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Incomplete Fine',
                    prefixIcon: Icon(Icons.money_off),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val.isEmpty) {
                      return null;
                    } else if (int.tryParse(val) == null) {
                      return 'Fine must be a valid number!';
                    } else if (int.parse(val) < 0) {
                      return 'Fine cannot be negative value!';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    task.incompleteFine = val.isEmpty ? 0 : int.parse(val);
                  },
                ),
                SizedBox(height: 20),
                FlatButton.icon(
                  onPressed: _saveTask,
                  icon: Icon(Icons.save),
                  label: Text('Save Task'),
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                )
              ],
            ),
          ),
          if (_isLoading) ScreenLoading(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _instructionFocusNode.dispose();
    super.dispose();
  }
}
