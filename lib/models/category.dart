import 'package:json_annotation/json_annotation.dart';
import 'package:money_pocket_flow/data/base_entity.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends BaseEntity {
  String? name;
  String? color;
  String? icon;
  DateTime? date;
  double? amount;

  Category({this.name, this.color, this.icon, this.date, this.amount});

  @override
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  factory Category.fromJson(Map<String, dynamic> map) =>
      _$CategoryFromJson(map);

  static Map<String, String> getFields() {
    return {
      'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
      'name': 'TEXT',
      'color': 'TEXT',
      'icon': 'TEXT',
      'date': 'TEXT'
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    Category category = _$CategoryFromJson(map);
    id = category.id;
    name = category.name;
    color = category.color;
    icon = category.icon;
    date = category.date;
  }

  factory Category.fromCategoryMap(Map<String, dynamic> json) {
    Category category = Category(
      name: json['name'] as String?,
      color: json['color'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
    );
    return category;
  }
}
