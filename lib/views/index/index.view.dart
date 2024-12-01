import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:money_pocket_flow/views/index/index.controller.dart';

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
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        child: PageView(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          children: <Widget>[
            Center(
              child: Text('First Page'),
            ),
            Center(
              child: Text('Second Page'),
            ),
            Center(
              child: Text('Third Page'),
            ),
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
          }),
    );
  }
}
