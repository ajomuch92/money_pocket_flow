import 'package:money_pocket_flow/data/database_manager.dart';
import 'package:money_pocket_flow/data/repository.dart';
import 'package:money_pocket_flow/dto/category.repository.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/models/utilities_class.dart';
import 'package:sqflite/sqflite.dart';

enum FilterDateType { currentMonth, lastWeek, today }

class TransactionRepository {
  final DatabaseManager dbManager = DatabaseManager();
  List<Category> listCategories = [];
  late final transactionRepository = Repository<TransactionModel>(
    dbManager,
    'transactions',
    () => TransactionModel(),
  );

  Future<void> loadCategories() async {
    listCategories = await CategoryRepository().getCategories();
  }

  Future<TransactionModel> getTransaction(int transactionId) async {
    try {
      TransactionModel transaction =
          await transactionRepository.getOneById(transactionId);
      return transaction;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveTransaction(TransactionModel transaction) async {
    try {
      if (transaction.id != null) {
        await transactionRepository.update(transaction);
      } else {
        int id = await transactionRepository.insert(transaction);
        transaction.id = id;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TransactionModel>> getTransactions(
      TransactionFilter filter) async {
    try {
      if (listCategories.isEmpty) {
        await loadCategories();
      }
      List<String> whereStr = [];
      List<dynamic> whereArgs = [];

      if (filter.type != null) {
        whereStr.add('type = ?');
        whereArgs.add(filter.type?.str);
      }
      if (filter.categoryId != null) {
        whereStr.add('categoryId = ?');
        whereArgs.add(filter.categoryId);
      }
      if (filter.initialDate != null) {
        whereStr.add('date >= ?');
        whereArgs.add(filter.initialDate?.toIso8601String());
      }
      if (filter.endDate != null) {
        whereStr.add('date <= ?');
        whereArgs.add(filter.endDate?.toIso8601String());
      }
      List<TransactionModel> list = await transactionRepository.getAll(
        limit: filter.limit,
        offset: (filter.page ?? 0) * (filter.limit ?? 0),
        where: whereStr.isNotEmpty ? whereStr.join(' AND ') : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      );
      for (var trx in list) {
        int index =
            listCategories.indexWhere((cat) => cat.id == trx.categoryId);
        trx.category = index != -1 ? listCategories[index] : null;
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<InOutResult> getTotalsFiltered(
      {FilterDateType type = FilterDateType.currentMonth}) async {
    try {
      final db = await dbManager.database;
      DateTime date = DateTime.now();
      if (type == FilterDateType.currentMonth) {
        date = DateTime(date.year, date.month, 1);
      } else if (type == FilterDateType.lastWeek) {
        date = date.subtract(const Duration(days: 7));
      } else {
        date = DateTime(date.year, date.month, date.day);
      }
      InOutResult result = InOutResult();
      result.inTotal = db.firstDoubleValue(await db.rawQuery(
          'SELECT SUM(AMOUNT) FROM transactions WHERE type = ? AND date > ?',
          ['in', date.toIso8601String()]));
      result.outTotal = db.firstDoubleValue(await db.rawQuery(
          'SELECT SUM(AMOUNT) FROM transactions WHERE type = ? AND date > ?',
          ['out', date.toIso8601String()]));
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Category>> getTotalsByCategory(
      {FilterDateType type = FilterDateType.currentMonth}) async {
    try {
      final db = await dbManager.database;
      DateTime date = DateTime.now();
      if (type == FilterDateType.currentMonth) {
        date = DateTime(date.year, date.month, 1);
      } else if (type == FilterDateType.lastWeek) {
        date = date.subtract(const Duration(days: 7));
      } else {
        date = DateTime(date.year, date.month, date.day);
      }
      List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT b.name, b.color, b.icon, SUM(a.amount) as amount FROM transactions AS a INNER JOIN categories AS b ON b.id = a.categoryId WHERE a.date > ? GROUP BY b.name, b.color, b.icon',
          [date.toIso8601String()]);
      List<Category> list =
          result.map((e) => Category.fromCategoryMap(e)).toList();
      list.sort((a, b) => b.amount!.compareTo(a.amount!));
      return list;
    } catch (e) {
      rethrow;
    }
  }
}

extension DatabaseDoubleExtensions on Database {
  double firstDoubleValue(List<Map<String, dynamic>> result) {
    return result.isNotEmpty &&
            result.first.values.isNotEmpty &&
            result.first.values.first != null
        ? (result.first.values.first as num).toDouble()
        : 0;
  }
}
