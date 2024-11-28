import 'package:json_annotation/json_annotation.dart';
import 'package:money_pocket_flow/data/base_entity.dart';

part 'category.g.dart';

@JsonSerializable()
class Category extends BaseEntity {
  String? name;
  String? color;
  String? icon;
  DateTime? date;

  Category({this.name, this.color, this.icon, this.date});

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
  void fromMap(Map<String, dynamic> map) => _$CategoryFromJson(map);
}
