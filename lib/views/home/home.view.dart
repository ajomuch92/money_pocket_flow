// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:money_pocket_flow/shared/CategoryTile.dart';
import 'package:money_pocket_flow/shared/ErrorEmpty.dart';
import 'package:money_pocket_flow/views/home/home.controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return ResourceBuilder(
        resource: controller.resourceSettings,
        builder: (context, settingsState) {
          return settingsState.on(
              ready: (settings) {
                String currencySymbol = settings.currencySymbol ?? '\$';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  width: MediaQuery.sizeOf(context).width,
                  child: ResourceBuilder(
                      resource: controller.resourceInOut,
                      builder: (context, inOutState) {
                        return inOutState.on(
                            ready: (totals) => SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              const Text(
                                                'Gastos Totales',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                '${currencySymbol} ${totals.outTotal}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 32,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SignalBuilder(
                                              signal:
                                                  controller.listSelectedOption,
                                              builder: (context,
                                                  selectedOptions, _) {
                                                return ToggleButtons(
                                                  isSelected: selectedOptions,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  onPressed: controller
                                                      .setSelectedOption,
                                                  constraints:
                                                      const BoxConstraints(
                                                    minHeight: 25.0,
                                                    minWidth: 50.0,
                                                  ),
                                                  children: const <Widget>[
                                                    Text('Mes'),
                                                    Text('Semana'),
                                                    Text('Hoy'),
                                                  ],
                                                );
                                              }),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 200.0,
                                        child: Placeholder(),
                                      ),
                                      ListTile(
                                        title: const Text('Gastos'),
                                        trailing: Text(
                                            '${currencySymbol} ${totals.outTotal}'),
                                      ),
                                      ListTile(
                                        title: const Text('Ingresos'),
                                        trailing: Text(
                                            '${currencySymbol} ${totals.inTotal}'),
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Detalles',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                  Icons.chevron_right),
                                            )
                                          ],
                                        ),
                                      ),
                                      ResourceBuilder(
                                        resource: controller.resourceCategories,
                                        builder: (context, categoriesState) {
                                          return categoriesState.on(
                                              ready: (categories) => categories
                                                      .isEmpty
                                                  ? const ErrorEmpty(
                                                      message:
                                                          'No hay transacciones guardadas',
                                                      fullHeight: false,
                                                      child: FluentUiEmojiIcon(
                                                        fl: Fluents
                                                            .flFaceWithDiagonalMouth,
                                                        w: 50,
                                                        h: 50,
                                                      ))
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final category =
                                                            categories[index];
                                                        return SingleCategoryTile(
                                                          category: category,
                                                          currencySymbol:
                                                              currencySymbol,
                                                          editable: false,
                                                        );
                                                      },
                                                      itemCount:
                                                          categories.length,
                                                    ),
                                              error: (e, t) => const ErrorEmpty(
                                                  message:
                                                      'Hubo un error al cargar los detalles'),
                                              loading: () => const Center(
                                                    child: GFLoader(),
                                                  ));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                            error: (e, t) => const ErrorEmpty(
                                message: 'Hubo un error al cargar los datos'),
                            loading: () => const Center(
                                  child: GFLoader(),
                                ));
                      }),
                );
              },
              error: (e, t) => const ErrorEmpty(
                  message: 'Hubo un error al cargar las configuraciones'),
              loading: () => const Center(
                    child: GFLoader(),
                  ));
        });
  }
}
