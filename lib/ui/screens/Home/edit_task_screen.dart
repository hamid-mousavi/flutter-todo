import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:todo/data/repo/Repository.dart';
import 'package:todo/main.dart';
import 'package:todo/task.dart';

class EditTaskScreen extends StatelessWidget {
  final TaskEntity task;
  const EditTaskScreen({super.key, required TaskEntity this.task});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    controller.text = task.name;
    final repository = Provider.of<Repository<TaskEntity>>(context);

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            task.name = controller.text;
            repository.updateOrCreate(task);
            Navigator.of(context).pop();
          },
          label: Text('Save')),
      body: Column(
        children: [
          PeriorityWidget(task: task),
          TextField(
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
              controller: controller)
        ],
      ),
    );
  }
}

class PeriorityWidget extends StatefulWidget {
  const PeriorityWidget({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<PeriorityWidget> createState() => _PeriorityWidgetState();
}

class _PeriorityWidgetState extends State<PeriorityWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ListTile(
          title: const Text('Low'),
          leading: Radio<Periority>(
            value: Periority.low,
            groupValue: widget.task.periority,
            onChanged: (value) {
              setState(() {
                widget.task.periority = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('medium'),
          leading: Radio<Periority>(
            value: Periority.medium,
            groupValue: widget.task.periority,
            onChanged: (value) {
              setState(() {
                widget.task.periority = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('high'),
          leading: Radio<Periority>(
            value: Periority.high,
            groupValue: widget.task.periority,
            onChanged: (value) {
              setState(() {
                widget.task.periority = value!;
              });
            },
          ),
        ),
      ]),
    );
  }
}
