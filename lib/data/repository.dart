import 'base_entity.dart';
import 'database_manager.dart';

class Repository<T extends BaseEntity> {
  final DatabaseManager _dbManager;
  final String _tableName;
  final T Function() entityFactory;

  Repository(this._dbManager, this._tableName, this.entityFactory);

  Future<int> insert(T entity) async {
    final db = await _dbManager.database;
    return await db.insert(_tableName, entity.toJson());
  }

  Future<int> update(T entity) async {
    if (entity.id == null) {
      throw Exception("Entity ID cannot be null for update");
    }
    final db = await _dbManager.database;
    return await db.update(
      _tableName,
      entity.toJson(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbManager.database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<T>> getAll(
      {bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    final db = await _dbManager.database;
    final maps = await db.query(_tableName,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
    return maps.map((map) {
      final entity = entityFactory();
      entity.fromMap(map);
      return entity;
    }).toList();
  }
}
