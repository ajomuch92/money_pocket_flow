import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_pocket_flow/data/database_manager.dart';
import 'package:money_pocket_flow/data/repository.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/utils/icons.dart';

class CategoryRepository {
  final DatabaseManager dbManager = DatabaseManager();
  late final categoryRepository = Repository<Category>(
    dbManager,
    'categories',
    () => Category(),
  );

  Future<List<Category>> getCategories() async {
    try {
      List<Category> list = await categoryRepository.getAll(limit: 1);
      list.add(Category()
        ..name = 'Test'
        ..icon = getNameByIcon(MdiIcons.accessPointMinus)
        ..color = const Color.fromRGBO(255, 0, 0, 1).asHexString
        ..date = DateTime.now());
      list.add(Category()
        ..name = 'Test'
        ..icon = getNameByIcon(MdiIcons.abTesting)
        ..color = const Color.fromRGBO(255, 255, 0, 1).asHexString
        ..date = DateTime.now());
      return list;
    } catch (e) {
      rethrow;
    }
  }
}
