import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/icon_map.dart';
import 'package:money_pocket_flow/dto/category.repository.dart';
import 'package:money_pocket_flow/models/index.dart';

class AddCategoryController {
  final selectedIcon = Signal('');
  final searchText = Signal('');
  final formKey = GlobalKey<FormBuilderState>();
  final bottomController = GFBottomSheetController();
  List<String> iconsKey = iconMap.keys.toList();
  final CategoryRepository repository = CategoryRepository();

  Signal<List<String>> listIcon = Signal(iconMap.keys.toList());

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

  Future<void> saveChanges(BuildContext context, int? categoryId) async {
    try {
      if (formKey.currentState!.saveAndValidate()) {
        Map<String, dynamic> values = formKey.currentState!.value;
        Category category = Category.fromJson(values);
        category.id = categoryId;
        if (category.id == null) {
          category.date = DateTime.now();
        }
        await repository.saveCategory(category);
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
}
