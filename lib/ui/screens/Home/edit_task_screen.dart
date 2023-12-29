import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/main.dart';
import 'package:todo/task.dart';

class EditTaskScreen extends StatelessWidget {
  final TaskEntity task;
  const EditTaskScreen({super.key, required TaskEntity this.task});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TaskEntity>(boxName);
    final controller = TextEditingController();
    controller.text = task.name;

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            task.name = controller.text;
            if (task.isInBox) {
              task.save();
            } else {
              box.add(task);
            }

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
          title: Text('Low'),
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
          title: Text('medium'),
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
          title: Text('high'),
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
