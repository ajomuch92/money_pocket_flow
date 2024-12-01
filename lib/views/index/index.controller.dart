import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';

class IndexController {
  Signal<int> selectedPage = Signal<int>(0);
  final PageController _pageViewController = PageController();

  late final title = Computed(() =>
      ['Inicio', 'Categorías', 'Configuración'].elementAt(selectedPage.value));

  PageController get pageController => _pageViewController;

  void setSelectedPage(int index) {
    selectedPage.value = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    selectedPage.value = index;
  }

  void dispose() {
    _pageViewController.dispose();
  }
}
