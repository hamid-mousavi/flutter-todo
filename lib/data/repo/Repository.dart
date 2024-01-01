import 'package:flutter/material.dart';
import 'package:todo/data/datasource/DataSource.dart';

class Repository<T> extends ChangeNotifier implements IDatasource<T> {
  final IDatasource<T> _datasource;

  Repository(this._datasource);
  @override
  Future<void> updateOrCreate(data) async {
    await _datasource.updateOrCreate(data);
    notifyListeners();
  }

  @override
  Future<List<T>> getAll({String searchKey = ''}) async {
    final items = await _datasource.getAll(searchKey: searchKey);
    return items;
  }

  @override
  Future<void> delete(T data) async {
    await _datasource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await _datasource.deleteAll();
    notifyListeners();
  }
}
