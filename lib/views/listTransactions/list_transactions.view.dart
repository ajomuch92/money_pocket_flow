import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_is_dark_color_hsp/flutter_is_dark_color_hsp.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/shared/ErrorEmpty.dart';
import 'package:money_pocket_flow/views/listTransactions/list_transactions.controller.dart';

class ListTransactions extends StatefulWidget {
  const ListTransactions({super.key});

  @override
  State<ListTransactions> createState() => _ListTransactionsState();
}

class _ListTransactionsState extends State<ListTransactions> {
  final controller = ListTransactionsController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista transacciones'),
        centerTitle: true,
      ),
      body: ResourceBuilder(
          resource: controller.resourceSettings,
          builder: (context, resourceState) {
            return resourceState.on(
                ready: (settings) {
                  return PagedListView<int, TransactionModel>(
                    pagingController: controller.pagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<TransactionModel>(
                      itemBuilder: (context, item, index) {
                        Color _color = HexColor(item.category!.color!);
                        return Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              _color,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ],
                          )),
                          child: ListTile(
                            title: Text('${item.description}'),
                            subtitle: Text(DateFormat.yMd().format(item.date!)),
                            leading: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: item.type == 'out'
                                    ? Colors.red.withOpacity(0.5)
                                    : Colors.green.withOpacity(0.5),
                              ),
                              child: Text(
                                  '${settings.currencySymbol} ${item.amount}'),
                            ),
                            trailing: Icon(
                                MdiIcons.fromString(
                                  item.category!.icon!,
                                ),
                                color: isDarkHsp(_color) ?? false
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (e, t) => const ErrorEmpty(
                    message: 'Hubo un error al cargar la configuración'),
                loading: () => const Center(
                      child: GFLoader(),
                    ));
          }),
    );
  }
}
