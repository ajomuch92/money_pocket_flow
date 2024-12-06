import 'package:animated_visibility/animated_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_pocket_flow/views/home/home.view.dart';
import 'package:money_pocket_flow/views/index/index.controller.dart';
import 'package:money_pocket_flow/views/settings/settings.view.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final controller = IndexController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: SignalBuilder<String>(
            signal: controller.title,
            builder: (context, value, child) {
              return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(value, key: ValueKey<String>(value)));
            }),
        centerTitle: true,
        actions: [
          SignalBuilder(
            signal: controller.selectedPage,
            builder: (context, value, child) {
              return AnimatedVisibility(
                visible: value == 2,
                enter: fadeIn() + scaleIn(),
                exit: fadeOut() + scaleOut(),
                enterDuration: const Duration(milliseconds: 300),
                exitDuration: const Duration(milliseconds: 300),
                child: SignalBuilder(
                    signal: controller.isEditting,
                    builder: (context, isEditting, _) {
                      return IconButton(
                        onPressed: controller.onActionButton,
                        icon: isEditting
                            ? Icon(MdiIcons.close)
                            : const Icon(Icons.edit),
                      );
                    }),
              );
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: PageView(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          children: <Widget>[
            Home(),
            Center(
              child: Text('Second Page'),
            ),
            Settings(),
          ],
        ),
      ),
      bottomNavigationBar: SignalBuilder<int>(
        signal: controller.selectedPage,
        builder: (context, value, child) {
          return FlashyTabBar(
            selectedIndex: value,
            showElevation: true,
            onItemSelected: controller.setSelectedPage,
            items: [
              FlashyTabBarItem(
                icon: const Icon(Icons.home),
                title: const Text('Inicio'),
                activeColor: Colors.blueAccent,
              ),
              FlashyTabBarItem(
                icon: const Icon(Icons.category),
                title: const Text('Categorías'),
                activeColor: Colors.blueAccent,
              ),
              FlashyTabBarItem(
                icon: const Icon(Icons.settings),
                title: const Text('Configuración'),
                activeColor: Colors.blueAccent,
              ),
            ],
          );
        },
      ),
      floatingActionButton: SignalBuilder(
        signal: controller.selectedPage,
        builder: (context, value, child) {
          return AnimatedVisibility(
            visible: value != 2,
            enter: fadeIn() + scaleIn(),
            exit: fadeOut() + scaleOut(),
            enterDuration: const Duration(milliseconds: 300),
            exitDuration: const Duration(milliseconds: 300),
            child: FloatingActionButton(
              onPressed: () {},
              disabledElevation: 0,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
