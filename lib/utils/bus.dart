import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class EventModel {
  String name;
  dynamic payload;

  EventModel({required this.name, this.payload});
}
