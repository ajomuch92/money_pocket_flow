import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_is_dark_color_hsp/flutter_is_dark_color_hsp.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/models/utilities_class.dart';
import 'package:money_pocket_flow/shared/ErrorEmpty.dart';
import 'package:money_pocket_flow/shared/decoration.dart';
import 'package:money_pocket_flow/views/listTransactions/list_transactions.controller.dart';
import 'package:separated_column/separated_column.dart';

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

  void showFilter(BuildContext context) {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: FormBuilder(
                key: controller.formKeyFilter,
                initialValue: {
                  'type': controller.filter.type,
                  'categoryId': controller.filter.categoryId,
                },
                child: SingleChildScrollView(
                  child: SeparatedColumn(
                    includeOuterSeparators: true,
                    separatorBuilder: (context, i) => SizedBox(
                      height: i % 2 == 0 ? 0 : 20,
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                      const GFTypography(
                        text: 'Tipo',
                        type: GFTypographyType.typo5,
                        showDivider: false,
                      ),
                      FormBuilderChoiceChip<TransactionType>(
                        name: 'type',
                        spacing: 10,
                        options: const [
                          FormBuilderChipOption(
                            value: TransactionType.inTrx,
                            child: Text('Ingreso'),
                          ),
                          FormBuilderChipOption(
                            value: TransactionType.outTrx,
                            child: Text('Gasto'),
                          ),
                        ],
                      ),
                      const GFTypography(
                        text: 'Categorías',
                        type: GFTypographyType.typo5,
                        showDivider: false,
                      ),
                      FormBuilderChoiceChip<int>(
                        name: 'categoryId',
                        spacing: 10,
                        options: controller.categories
                            .map((category) => FormBuilderChipOption(
                                  value: category.id!,
                                  child: Text(category.name!),
                                ))
                            .toList(),
                      ),
                      const GFTypography(
                        text: 'Fecha',
                        type: GFTypographyType.typo5,
                        showDivider: false,
                      ),
                      FormBuilderDateRangePicker(
                        name: 'date',
                        decoration: customInputDecoration,
                        lastDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        saveText: 'Establecer',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GFButton(
                            onPressed: () {
                              controller.setFilters(context);
                            },
                            text: 'Aplicar filtros',
                            size: GFSize.LARGE,
                          ),
                          GFButton(
                            onPressed: () {
                              controller.resetFilters(context);
                            },
                            text: 'Limpiar filtros',
                            type: GFButtonType.outline,
                            size: GFSize.LARGE,
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista transacciones'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showFilter(context);
              },
              icon: Icon(MdiIcons.filter))
        ],
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
                        Color _color = item.category != null
                            ? HexColor(item.category!.color!)
                            : Colors.lightGreenAccent;
                        return Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              _color,
                            ],
                          )),
                          child: ListTile(
                            title: Text('${item.description}'),
                            onTap: () {
                              controller.navigateDetails(item, context);
                            },
                            subtitle: Text(
                                DateFormat('dd/MM/yyyy').format(item.date!)),
                            trailing: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: item.type == 'out'
                                    ? Colors.red.withOpacity(0.9)
                                    : Colors.green.withOpacity(0.9),
                              ),
                              child: Text.rich(
                                TextSpan(
                                  text:
                                      '${settings.currencySymbol} ${item.amount}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: item.type == 'out' ? '↗︎' : '↙︎',
                                      style: GoogleFonts.notoEmoji(
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            leading: Icon(
                              item.category != null
                                  ? MdiIcons.fromString(
                                      item.category!.icon!,
                                    )
                                  : MdiIcons.arrowBottomLeft,
                              color: isDarkHsp(_color) ?? false
                                  ? Colors.white
                                  : Colors.black,
                            ),
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
