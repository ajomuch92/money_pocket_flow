import 'package:json_annotation/json_annotation.dart';
import 'package:money_pocket_flow/data/base_entity.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings extends BaseEntity {
  String? currencySymbol;
  String? language;
  String? theme;

  Settings({this.currencySymbol, this.language, this.theme});

  @override
  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  factory Settings.fromJson(Map<String, dynamic> map) =>
      _$SettingsFromJson(map);

  static Map<String, String> getFields() {
    return {
      'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
      'currencySymbol': 'TEXT',
      'language': 'TEXT',
      'theme': 'TEXT'
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    Settings newSettings = _$SettingsFromJson(map);
    id = newSettings.id;
    currencySymbol = newSettings.currencySymbol;
    theme = newSettings.currencySymbol;
    language = newSettings.language;
  }
}
