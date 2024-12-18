import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:money_pocket_flow/dto/category.repository.dart';
import 'package:money_pocket_flow/dto/transaction.repository.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/models/utilities_class.dart';

class AddCategoryController {
  final selectedIcon = Signal('');
  final searchText = Signal('');
  final formKey = GlobalKey<FormBuilderState>();
  final bottomController = GFBottomSheetController();
  List<String> iconsKey = iconMap.keys.toList();
  final CategoryRepository repository = CategoryRepository();
  Signal<int?> categoryId = Signal<int?>(null);
  late Resource<Category> resource;

  Signal<List<String>> listIcon = Signal(iconMap.keys.toList());

  AddCategoryController() {
    resource = Resource<Category>(fetcher: getCategory, source: categoryId);
  }

  void onSearch(String searchValue) {
    if (searchValue.isEmpty) {
      listIcon.value = iconsKey;
    } else {
      listIcon.value = iconsKey
          .where((iconName) =>
              iconName.toLowerCase().contains(searchValue.toLowerCase()))
          .toList();
    }
  }

  void setActiveIcon(String iconName) {
    selectedIcon.value = iconName;
  }

  void setCategoryId(int? id) {
    categoryId.value = id;
  }

  Future<Category> getCategory() async {
    if (categoryId.value != null) {
      Category cat = await repository.getCategory(categoryId.value!);
      setActiveIcon(cat.icon!);
      return cat;
    }
    return Category();
  }

  Future<void> saveChanges(BuildContext context) async {
    try {
      if (formKey.currentState!.saveAndValidate()) {
        Map<String, dynamic> values = formKey.currentState!.value;
        Category category = Category.fromJson(values);
        category.id = categoryId.value;
        category.date =
            category.id == null ? DateTime.now() : resource.state.value?.date;
        if (category.id == null) {
          category.date = DateTime.now();
        }
        await repository.saveCategory(category);
        if (!context.mounted) return;
        context.pop(true);
        GFToast.showToast(
          'Cambios guardados.',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          textStyle: const TextStyle(fontSize: 16, color: GFColors.DARK),
          backgroundColor: GFColors.LIGHT,
          trailing: const Icon(
            Icons.check,
          ),
        );
      } else {
        GFToast.showToast(
          'Ingresa todos los campos para continuar',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          textStyle: const TextStyle(fontSize: 16, color: GFColors.DARK),
          backgroundColor: GFColors.WARNING,
          trailing: const Icon(
            Icons.warning,
          ),
        );
      }
    } catch (e) {
      GFToast.showToast(
        'Hubo un error al guardar tus cambios.',
        context,
        toastPosition: GFToastPosition.BOTTOM,
        textStyle: const TextStyle(fontSize: 16, color: GFColors.WHITE),
        backgroundColor: GFColors.DANGER,
        trailing: const Icon(
          Icons.error,
          color: GFColors.WHITE,
        ),
      );
    }
  }

  Future<void> deleteCategory(BuildContext context) async {
    if (categoryId.value == null || !context.mounted) return;
    try {
      if (!(await validateCategory(categoryId.value!))) {
        GFToast.showToast(
          'No se puede eliminar una categoría asociada a transacciones',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          textStyle: const TextStyle(fontSize: 16, color: GFColors.WHITE),
          backgroundColor: GFColors.WARNING,
          trailing: const Icon(
            Icons.error,
            color: GFColors.WHITE,
          ),
        );
        return;
      }
      final answer = await confirm(
        context,
        title: const Text('Eliminar'),
        content: const Text('¿Deseas eliminar esta categoría?'),
        textOK: const Text('Sí'),
        textCancel: const Text('No'),
      );
      if (answer) {
        await repository.deleteCategory(categoryId.value!);
        context.pop(true);
        GFToast.showToast(
          'Categoría eliminada.',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          textStyle: const TextStyle(fontSize: 16, color: GFColors.DARK),
          backgroundColor: GFColors.LIGHT,
          trailing: const Icon(
            Icons.check,
          ),
        );
      }
    } catch (e) {
      GFToast.showToast(
        'Hubo un error al elimina tu categoría.',
        context,
        toastPosition: GFToastPosition.BOTTOM,
        textStyle: const TextStyle(fontSize: 16, color: GFColors.WHITE),
        backgroundColor: GFColors.DANGER,
        trailing: const Icon(
          Icons.error,
          color: GFColors.WHITE,
        ),
      );
    }
  }

  Future<bool> validateCategory(int categoryId) async {
    List<TransactionModel> trxs = await TransactionRepository()
        .getTransactions(TransactionFilter(categoryId: categoryId));
    return trxs.isEmpty;
  }
}
