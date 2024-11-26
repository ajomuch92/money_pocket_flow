import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  @Id()
  int id = 0;

  String? name;
  String? type;
  String? color;
  String? icon;

  @Property(type: PropertyType.date)
  DateTime? date;
}
