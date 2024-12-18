import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/utils/bus.dart';

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
                : Colors.black,
          ),
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
      trailing: IconButton(
          onPressed: () {
            context.push('/edit-category/${category.id}').then((value) {
              if (value == true) {
                EventModel.eventBus.fire(EventModel(name: 'reload-categories'));
              }
            });
          },
          icon: const Icon(Icons.edit)),
    );
  }
}

class SingleCategoryTile extends StatelessWidget {
  final Category category;
  final String currencySymbol;
  const SingleCategoryTile(
      {super.key, required this.category, this.currencySymbol = '\$'});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: HexColor(category.color!).withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.fromString(category.icon!),
            size: 32,
          ),
          Text(
            category.name!,
            style: const TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '$currencySymbol ${category.amount}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
