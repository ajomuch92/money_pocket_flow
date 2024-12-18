// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pocket_flow/shared/CategoryTile.dart';
import 'package:money_pocket_flow/shared/DonutChart.dart';
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
                                      Center(
                                        child: ResourceBuilder(
                                          resource:
                                              controller.resourceCategories,
                                          builder: (context, categoriesState) {
                                            return categoriesState.on(
                                                ready: (categories) => categories
                                                        .isEmpty
                                                    ? const ErrorEmpty(
                                                        message:
                                                            'No hay transacciones para mostrar',
                                                        fullHeight: false,
                                                        child:
                                                            FluentUiEmojiIcon(
                                                          fl: Fluents
                                                              .flFaceWithDiagonalMouth,
                                                          w: 50,
                                                          h: 50,
                                                        ))
                                                    : DonutChart(
                                                        categories: categories,
                                                      ),
                                                error: (e, t) => const ErrorEmpty(
                                                    message:
                                                        'Hubo un error al cargar los detalles'),
                                                loading: () => const Center(
                                                      child: GFLoader(),
                                                    ));
                                          },
                                        ),
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Tooltip(
                                            message: 'Ingresos',
                                            child: Container(
                                              height: 100,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Stack(
                                                children: [
                                                  const Positioned(
                                                    right: 10,
                                                    top: 0,
                                                    child: Text(
                                                      '↙︎',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      '${currencySymbol} ${totals.inTotal}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 32,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Tooltip(
                                            message: 'Gastos',
                                            child: Container(
                                              height: 100,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Stack(
                                                children: [
                                                  const Positioned(
                                                    right: 10,
                                                    top: 0,
                                                    child: Text(
                                                      '↗︎',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      '${currencySymbol} ${totals.outTotal}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 32,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      const SizedBox(
                                        height: 10,
                                      ),
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
                                            InkWell(
                                              child: const Text(
                                                'Ver todos',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              onTap: () {
                                                context
                                                    .push('/list-transactions');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
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
                                                  : SizedBox(
                                                      height: 150,
                                                      child: ListView.separated(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                const SizedBox(
                                                          width: 10,
                                                        ),
                                                        itemBuilder:
                                                            (context, index) {
                                                          final category =
                                                              categories[index];
                                                          return SingleCategoryTile(
                                                            category: category,
                                                            currencySymbol:
                                                                currencySymbol,
                                                          );
                                                        },
                                                        itemCount:
                                                            categories.length,
                                                      ),
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
