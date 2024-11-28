import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'base_entity.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  Database? _database;
  final Map<Type, String> _entityTableMap = {}; // Mapeo de entidades y tablas.

  DatabaseManager._internal();

  factory DatabaseManager() => _instance;

  // Registrar una entidad con su tabla.
  void registerEntity<T extends BaseEntity>(String tableName) {
    _entityTableMap[T] = tableName;
  }

  // Obtener la instancia de la base de datos.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos y crear las tablas dinámicamente.
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'app_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        for (var entry in _entityTableMap.entries) {
          final fields = BaseEntity.getFields(entry.key);
          final columns =
              fields.entries.map((e) => '${e.key} ${e.value}').join(', ');
          final createTableQuery = 'CREATE TABLE ${entry.value} ($columns)';
          await db.execute(createTableQuery);
        }
      },
    );
  }
}
