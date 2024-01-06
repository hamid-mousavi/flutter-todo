import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/repo/Repository.dart';
import 'package:todo/task.dart';
import 'package:todo/ui/screens/Edit/bloc/edit_task_bloc.dart';
import 'package:todo/ui/screens/Home/bloc/task_list_bloc.dart';

import '../Edit/edit_task_screen.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    final TextEditingController searchController = TextEditingController();
    final themeData = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: BlocProvider<EditTaskBloc>(
            create: (context) => EditTaskBloc(
                context.read<Repository<TaskEntity>>(), TaskEntity()),
            child: const Icon(CupertinoIcons.add),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                final task = TaskEntity();
                return EditTaskScreen(
                  task: task,
                );
              },
            ));
          },
        ),
        body: Column(
          children: [
            Container(
              color: themeData.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const HeaderAppBar(),
                    const SizedBox(height: 20),
                    SearchBarWidget(searchController: searchController),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Today'),
                  const SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      context.read<TaskListBloc>().add(TaslistDeleteAll());
                    },
                    child: const Text('Delete All'),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TaskItemsListWidget(
                  controller: controller, searchController: searchController),
            )),
          ],
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(CupertinoIcons.search)),
          controller: searchController,
          onChanged: (value) {
            context.read<TaskListBloc>().add(TasklistSearch(value));
          },
        ),
      ),
    );
  }
}

class HeaderAppBar extends StatelessWidget {
  const HeaderAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Todo List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Icon(CupertinoIcons.share),
        ]);
  }
}

class TaskItemsListWidget extends StatelessWidget {
  const TaskItemsListWidget({
    super.key,
    required this.controller,
    required this.searchController,
  });

  final ScrollController controller;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository<TaskEntity>>(
      builder: (context, model, child) {
        context.read<TaskListBloc>().add(TasklistStarted());
        return BlocBuilder<TaskListBloc, TaskListState>(
          builder: (context, state) {
            if (state is TaskListSucccess) {
              final items = state.tasks;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final TaskEntity task = items[index];
                  return Container(
                    height: 50,
                    child: TaskItemWidget(task: task),
                  );
                },
              );
            } else if (state is TaskListEmpty) {
              return const Text('Empty Task');
            } else if (state is TaskListError) {
              return Container(
                child: Text('Error'),
              );
            } else if (state is TaskListLoading || state is TaskListInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Text('data');
            }
          },
        );
      },
    );
  }
}

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItemWidget> createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  @override
  Widget build(BuildContext context) {
    MaterialColor periorityColor = Colors.red;
    switch (widget.task.periority) {
      case Periority.low:
        periorityColor = Colors.purple;
        break;
      case Periority.medium:
        periorityColor = Colors.blue;
        break;
      case Periority.high:
        periorityColor = Colors.red;
        break;
      default:
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider<EditTaskBloc>(
              create: (context) => EditTaskBloc(
                  context.read<Repository<TaskEntity>>(), widget.task),
              child: EditTaskScreen(task: widget.task)),
        ));
      },
      onLongPress: () {
        final repository =
            Provider.of<Repository<TaskEntity>>(context, listen: false);
        repository.delete(widget.task);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
            value: widget.task.isCompleted,
            onChanged: (value) {
              setState(() {
                widget.task.isCompleted = value!;
                widget.task.save();
              });
            },
          ),
          Text(widget.task.name),
          PeriorityColor(widget.task, periorityColor)
        ],
      ),
    );
  }

  PeriorityColor(TaskEntity task, MaterialColor periorityColor) {
    return Container(
      width: 7,
      height: 48,
      decoration: BoxDecoration(
        color: periorityColor,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
    );
  }
}
