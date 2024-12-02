import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'base_entity.dart';
import 'package:money_pocket_flow/models/index.dart';

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
    _database = await createDatabase();
    return _database!;
  }

  // Inicializar la base de datos y crear las tablas dinámicamente.
  Future<Database> createDatabase() async {
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

  static Future<void> initDatabase() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
    }
    final dbManager = DatabaseManager();
    dbManager.registerEntity<TransactionModel>('transactions');
    dbManager.registerEntity<Settings>('settings');
    dbManager.registerEntity<Category>('categories');
    await dbManager.createDatabase();
    // final transactionRepo = Repository<TransactionModel>(
    //   dbManager,
    //   'transactions',
    //   ((map) => TransactionModel.fromJson(map)) as TransactionModel Function(),
    // );
  }
}
