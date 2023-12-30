import 'package:hive_flutter/adapters.dart';
import 'package:todo/data/datasource/DataSource.dart';
import 'package:todo/task.dart';

class HiveDatabase implements IDatasource<TaskEntity> {
  final Box<TaskEntity> box;

  HiveDatabase({required this.box});
  @override
  Future<List<TaskEntity>> getAll({String searchKey = ''}) async {
    return box.values.toList();
  }

  @override
  Future<void> updateOrCreate(TaskEntity data) async {
    if (data.isInBox) {
      data.save();
    } else {
      box.add(data);
    }
  }
}
