import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messman/models/task.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/services/members_service.dart';
import 'package:messman/services/tasks_service.dart';
import 'package:provider/provider.dart';

class UsersTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<TasksService>(context);
    final List<Task> tasks = taskService.upcomingTasks(
      userId: Provider.of<AuthService>(context, listen: false).user.id,
    );
    if (tasks.length <= 0) {
      return Text(
        ' No remaining task found this week, chill out!',
        style: TextStyle(color: Theme.of(context).primaryColorLight),
      );
    }
    return Column(
      children: tasks.map((e) => TaskItemCard(task: e)).toList(),
    );
  }
}

class TaskItemCard extends StatelessWidget {
  final Task task;
  const TaskItemCard({
    @required this.task,
  });

  Widget leadingChild() {
    if (task.status == 'complete') {
      return Icon(Icons.check);
    } else if (task.status == 'incomplete') {
      return Icon(Icons.cancel);
    }
    return Icon(Icons.local_drink);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Task>.value(
      value: task,
      child: Card(
        elevation: 2,
        child: Dismissible(
          key: Key('${task.id ?? 0}'),
          child: Consumer<Task>(
            builder: (ctx, task, child) => Container(
              color: task.shouldHighlight()
                  ? Theme.of(context).primaryColorLight
                  : Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  child: leadingChild(),
                  backgroundColor: task.status == 'incomplete'
                      ? Theme.of(context).errorColor
                      : Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                title: Text(
                  task.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(DateFormat('h:mm a').format(task.dateTime)),
                    SizedBox(height: 2),
                    Text(DateFormat('E, MMM d').format(task.dateTime)),
                  ],
                ),
                subtitle: Text(
                    Provider.of<MembersService>(context, listen: false)
                        .memberById(task.memberId)
                        .name),
              ),
            ),
          ),
          background: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 10),
                    Text('Mark as Complete!'),
                  ],
                ),
              ),
            ),
          ),
          secondaryBackground: Container(
            color: Theme.of(context).errorColor,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('Mark as Incomplete!'),
                  SizedBox(width: 10),
                  Icon(Icons.cancel),
                ],
              ),
            ),
          ),
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              child: AlertDialog(
                title: Text('Are you sure?'),
                content: Text(
                    'You want to mark this task as ${direction == DismissDirection.endToStart ? 'Incomplete' : 'Complete'}?'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () {
                      task
                          .updateStatus(
                        newStatus: direction == DismissDirection.endToStart
                            ? 'incomplete'
                            : 'complete',
                        token: Provider.of<AuthService>(
                          context,
                          listen: false,
                        ).token,
                      )
                          .catchError((error) {
                        if (context != null) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())),
                          );
                        } else {
                          print(error);
                        }
                      });
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Yes'),
                    color: direction == DismissDirection.endToStart
                        ? Theme.of(context).errorColor
                        : Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              // Mark as incomplete!
            } else {
              // Mark as complete
            }
          },
        ),
      ),
    );
  }
}
