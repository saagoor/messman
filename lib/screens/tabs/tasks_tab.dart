import 'package:flutter/material.dart';
import 'package:messman/models/task.dart';
import 'package:messman/screens/save_task_screen.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/includes/helpers.dart';
import 'package:messman/services/tasks_service.dart';
import 'package:messman/widgets/list_view_empty.dart';
import 'package:messman/widgets/no_scaffold_fab.dart';
import 'package:messman/widgets/user/users_tasks.dart';
import 'package:provider/provider.dart';

class TasksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TasksTabContent();
  }
}

class TasksTabContent extends StatefulWidget {
  @override
  _TasksTabContentState createState() => _TasksTabContentState();
}

class _TasksTabContentState extends State<TasksTabContent>
    with TickerProviderStateMixin {
  TabController _tabController;
  int _index = 0;

  AuthService auth;
  TasksService tasksService;

  Future<void> _loadTasks() async {
    await tasksService
        .fetchAndSet()
        .catchError((error) => showHttpError(context, error));
  }

  @override
  Widget build(BuildContext context) {
    tasksService = Provider.of<TasksService>(context);
    auth = Provider.of<AuthService>(context);
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _loadTasks,
          child: Column(
            children: <Widget>[
              SizedBox(
                // height: 50,
                child: TabBar(
                  tabs: [
                    Tab(text: 'My Tasks'),
                    Tab(text: 'Whole Mess'),
                    Tab(text: 'Old Tasks'),
                  ],
                  controller: _tabController,
                  onTap: (i) {
                    setState(() {
                      _index = i;
                    });
                  },
                ),
              ),
              Expanded(child: TasksListView(getTasks(_index))),
            ],
          ),
        ),
        NoScaffoldFAB(
          onPressed: () {
            Navigator.of(context).pushNamed(SaveTaskScreen.routeName);
          },
          child: Icon(Icons.add),
        )
      ],
    );
  }

  List<Task> getTasks(int index) {
    switch (index) {
      case 0:
        return tasksService.usersTasks(
          userId: Provider.of<AuthService>(context, listen: false).user.id,
        );
      case 1:
        return tasksService.items;
      case 2:
        return tasksService.oldItems;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class TasksListView extends StatelessWidget {
  final List<Task> tasks;
  final double reduceSize;
  TasksListView(this.tasks, {this.reduceSize = 0});

  @override
  Widget build(BuildContext context) {
    if (tasks == null || tasks.length <= 0) {
      return ListViewEmpty(
        text: 'No task found!',
        reduceSize: reduceSize,
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, i) {
        Widget append = SizedBox();
        if (i == 0) {
          append = Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 5, top: 5),
            child: Text(getWeek(tasks[i].dateTime.day)),
          );
        } else {
          if (weekNumber(tasks[i].dateTime) !=
              weekNumber(tasks[i - 1].dateTime)) {
            append = Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 5, top: 5),
              child: Text(getWeek(tasks[i].dateTime.day)),
            );
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            append,
            TaskItemCard(task: tasks[i]),
            SizedBox(height: 6),
          ],
        );
      },
      padding: EdgeInsets.all(10),
    );
  }
}
