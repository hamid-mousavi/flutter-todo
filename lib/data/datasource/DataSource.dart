import 'dart:io';

abstract class IDatasource<T> {
  Future<void> updateOrCreate(T data);
  Future<List<T>> getAll({String searchKey = ''});
}
