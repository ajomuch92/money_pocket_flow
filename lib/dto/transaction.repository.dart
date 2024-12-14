import 'package:money_pocket_flow/data/database_manager.dart';
import 'package:money_pocket_flow/data/repository.dart';
import 'package:money_pocket_flow/models/index.dart';

class TransactionRepository {
  final DatabaseManager dbManager = DatabaseManager();
  late final transactionRepository = Repository<TransactionModel>(
    dbManager,
    'transactions',
    () => TransactionModel(),
  );

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
}
