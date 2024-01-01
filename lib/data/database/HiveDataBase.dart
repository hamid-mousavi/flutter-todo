import 'package:hive_flutter/adapters.dart';
import 'package:todo/data/datasource/DataSource.dart';
import 'package:todo/task.dart';

class HiveDatabase implements IDatasource<TaskEntity> {
  final Box<TaskEntity> box;

  HiveDatabase({required this.box});
  @override
  Future<List<TaskEntity>> getAll({String searchKey = ''}) async {
    if (searchKey.isEmpty) {
      return box.values.toList();
    } else {
      return box.values
          .where((element) => element.name.contains(searchKey))
          .toList();
    }
  }

  @override
  Future<void> updateOrCreate(TaskEntity data) async {
    if (data.isInBox) {
      data.save();
    } else {
      box.add(data);
    }
  }

  @override
  Future<void> delete(TaskEntity data) async {
    await data.delete();
  }

  @override
  Future<void> deleteAll() async {
    await box.clear();
  }
}
