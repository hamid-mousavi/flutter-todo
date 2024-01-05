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
    return Scaffold(
      appBar: AppBar(title: const Text("Todo List")),
      floatingActionButton: FloatingActionButton(
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
          child: BlocProvider<EditTaskBloc>(
            create: (context) =>
                EditTaskBloc(context.read<Repository<TaskEntity>>()),
            child: const Text(
              '+',
              style: TextStyle(fontSize: 20),
            ),
          )),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                context.read<TaskListBloc>().add(TaslistDeleteAll());
              },
              child: Text('Delete All')),
          TextField(
            controller: searchController,
            onChanged: (value) {
              context.read<TaskListBloc>().add(TasklistSearch(value));
            },
          ),
          Expanded(
              child: TaskItemsListWidget(
                  controller: controller, searchController: searchController)),
        ],
      ),
    );
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
                  return TaskItemWidget(task: task);
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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BlocProvider<EditTaskBloc>(
              create: (context) =>
                  EditTaskBloc(context.read<Repository<TaskEntity>>()),
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
          Text(widget.task.periority.toString())
        ],
      ),
    );
  }
}
