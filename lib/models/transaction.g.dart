// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      categoryId: (json['categoryId'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      type: json['type'] as String?,
      description: json['description'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      favorite: json['favorite'] as bool?,
    )..id = (json['id'] as num?)?.toInt();

Map<String, dynamic> _$TransactionToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'amount': instance.amount,
      'type': instance.type,
      'description': instance.description,
      'favorite': instance.favorite,
      'date': instance.date?.toIso8601String(),
    };
