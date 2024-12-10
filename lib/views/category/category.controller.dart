import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:money_pocket_flow/dto/category.repository.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/utils/bus.dart';

class CategoryController {
  final CategoryRepository repository = CategoryRepository();
  final EventBus eventBus = EventModel.eventBus;
  late Resource<List<Category>> resource;
  late StreamSubscription eventSubscription;

  CategoryController() {
    resource = Resource(fetcher: getCategories);
    eventSubscription = eventBus.on<EventModel>().listen((event) {
      if (event.name == 'reload-categories') {
        resource.refresh();
      }
    });
  }

  Future<List<Category>> getCategories() async {
    try {
      return await repository.getCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() async {
    await eventSubscription.cancel();
  }
}
