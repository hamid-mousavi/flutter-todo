import 'package:todo/data/datasource/DataSource.dart';

class Repository<T> implements IDatasource {
  final IDatasource _datasource;

  Repository({required IDatasource datasource}) : _datasource = datasource;
  @override
  @override
  Future<void> updateOrCreate(data) {
    return _datasource.updateOrCreate(data);
  }

  @override
  Future<List> getAll({String searchKey = ''}) {
    return _datasource.getAll(searchKey: searchKey);
  }
}
