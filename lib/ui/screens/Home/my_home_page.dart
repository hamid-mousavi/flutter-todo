import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/repo/Repository.dart';
import 'package:todo/main.dart';
import 'package:todo/task.dart';

import 'edit_task_screen.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage();

  //bool ch = true;
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(boxName);

    final ScrollController controller = ScrollController();
    final TextEditingController searchController = TextEditingController();
    ValueNotifier<String> searchNotifier = ValueNotifier('');
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
          child: const Text(
            '+',
            style: TextStyle(fontSize: 20),
          )),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                final repository =
                    Provider.of<Repository<TaskEntity>>(context, listen: false);
                repository.deleteAll();
              },
              child: Text('Delete All')),
          TextField(
            controller: searchController,
            onChanged: (value) {
              searchNotifier.value = value;
            },
          ),
          Expanded(
              child: TaskItemsListWidget(
                  searchNotifier: searchNotifier,
                  box: box,
                  controller: controller,
                  searchController: searchController)),
        ],
      ),
    );
  }
}

class TaskItemsListWidget extends StatelessWidget {
  const TaskItemsListWidget({
    super.key,
    required this.searchNotifier,
    required this.box,
    required this.controller,
    required this.searchController,
  });

  final ValueNotifier<String> searchNotifier;
  final Box<TaskEntity> box;
  final ScrollController controller;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: searchNotifier,
      builder: (context, value, child) {
        return Consumer<Repository<TaskEntity>>(
          builder: (context, repository, child) {
            return FutureBuilder<List<TaskEntity>>(
              future: repository.getAll(searchKey: searchController.text),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final TaskEntity task = snapshot.data![index];
                      return TaskItemWidget(task: task);
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
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
          builder: (context) => EditTaskScreen(task: widget.task),
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
