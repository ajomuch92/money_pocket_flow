import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pocket_flow/utils/bus.dart';

class IndexController {
  Signal<int> selectedPage = Signal<int>(0);
  Signal<bool> isEditting = Signal<bool>(false);
  final EventBus _eventBus = EventModel.eventBus;
  final PageController _pageViewController = PageController();
  late StreamSubscription eventSubscription;
  final eventBus = EventModel.eventBus;

  IndexController() {
    eventSubscription = eventBus.on<EventModel>().listen((event) {
      if (event.name == 'settings-saved') {
        isEditting.value = false;
      }
    });
  }

  late final title = Computed(() =>
      ['Inicio', 'Categorías', 'Configuración'].elementAt(selectedPage.value));

  PageController get pageController => _pageViewController;

  void setSelectedPage(int index) {
    selectedPage.value = index;
    _pageViewController.jumpToPage(
      index,
    );
  }

  void onPageChanged(int index) {
    selectedPage.value = index;
  }

  void dispose() async {
    await eventSubscription.cancel();
    _pageViewController.dispose();
  }

  void onActionButton() {
    if (isEditting.value) {
      _eventBus.fire(EventModel(name: 'cancel-edit-settings'));
    } else {
      _eventBus.fire(EventModel(name: 'begin-edit-settings'));
    }
    isEditting.value = !isEditting.value;
  }

  void onFloatinActionButton(BuildContext context) {
    if (selectedPage.value == 0) {
      context.push('/new-trx');
    } else if (selectedPage.value == 1) {
      context.push('/new-category').then((value) {
        if (value == true) {
          _eventBus.fire(EventModel(name: 'reload-categories'));
        }
      });
    }
  }
}
