// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      currencySymbol: json['currencySymbol'] as String?,
      language: json['language'] as String?,
      theme: json['theme'] as String?,
    )..id = (json['id'] as num?)?.toInt();

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'id': instance.id,
      'currencySymbol': instance.currencySymbol,
      'language': instance.language,
      'theme': instance.theme,
    };
