import 'package:event_bus/event_bus.dart';

class EventModel {
  String name;
  dynamic payload;

  EventModel({required this.name, this.payload});

  static final EventBus eventBus = EventBus();
}
