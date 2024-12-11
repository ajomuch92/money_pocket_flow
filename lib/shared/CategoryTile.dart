import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_pocket_flow/models/index.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 3),
      title: Text(
        category.name!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(category.date == null
          ? 'N/A'
          : DateFormat.yMd().format(category.date!)),
      leading: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: category.color != null
              ? HexColor(category.color!).lighter(95)
              : Colors.transparent,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
          border: Border.all(
              color: category.color != null
                  ? HexColor(category.color!)
                  : Colors.black),
        ),
        child: Center(
          child: Icon(
            MdiIcons.fromString(category.icon!),
            size: 48,
            color: category.color != null
                ? HexColor(category.color!)
                : Colors.black,
          ),
        ),
      ),
      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
    );
  }
}
