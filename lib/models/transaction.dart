import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Transaction {
  @Id()
  int id = 0;

  @Property(type: PropertyType.int)
  int? categoryId;

  @Property(type: PropertyType.float)
  double? amount;

  String? type;
  String? description;

  bool? favorite;

  @Property(type: PropertyType.date)
  DateTime? date;

  final category = ToOne<Category>();
}
