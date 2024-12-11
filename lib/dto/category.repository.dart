import 'package:money_pocket_flow/data/database_manager.dart';
import 'package:money_pocket_flow/data/repository.dart';
import 'package:money_pocket_flow/models/index.dart';

class CategoryRepository {
  final DatabaseManager dbManager = DatabaseManager();
  late final categoryRepository = Repository<Category>(
    dbManager,
    'categories',
    () => Category(),
  );

  Future<List<Category>> getCategories() async {
    try {
      List<Category> list = await categoryRepository.getAll();
      return list;
    } catch (e) {
      rethrow;
    }
  }

  saveCategory(Category category) async {
    try {
      if (category.id != null) {
        await categoryRepository.update(category);
      } else {
        int id = await categoryRepository.insert(category);
        category.id = id;
      }
    } catch (e) {
      rethrow;
    }
  }
}
