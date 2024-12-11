import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_pocket_flow/shared/CategoryTile.dart';
import 'package:money_pocket_flow/shared/ErrorEmpty.dart';
import 'package:money_pocket_flow/views/category/category.controller.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final CategoryController controller = CategoryController();

  @override
  void dispose() async {
    // await controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResourceBuilder(
        resource: controller.resource,
        builder: (context, resourceState) {
          return resourceState.on(
              ready: (data) {
                if (data.isEmpty) {
                  return ErrorEmpty(
                    message: 'No hay categorías creadas',
                    child: Icon(
                      MdiIcons.imageBroken,
                      size: 128.0,
                      color: Colors.blueGrey,
                    ),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return CategoryTile(category: data[index]);
                  },
                  itemCount: data.length,
                );
              },
              error: (error, _) => const Center(
                    child: Text('Hubo un error al cargar las configuraciones'),
                  ),
              loading: () => const Center(
                    child: GFLoader(),
                  ));
        });
  }
}
