abstract class IDatasource<T> {
  Future<void> updateOrCreate(T data);
  Future<void> deleteAll();
  Future<void> delete(T data);
  Future<List<T>> getAll({String searchKey = ''});
}
