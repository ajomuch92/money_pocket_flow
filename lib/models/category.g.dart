// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      name: json['name'] as String?,
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    )..id = (json['id'] as num?)?.toInt();

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'icon': instance.icon,
      'date': instance.date?.toIso8601String(),
    };
