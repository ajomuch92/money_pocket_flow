import 'package:json_annotation/json_annotation.dart';
import 'package:money_pocket_flow/data/base_entity.dart';
import 'package:money_pocket_flow/models/category.dart';

part 'transaction.g.dart';

@JsonSerializable()
class TransactionModel extends BaseEntity {
  int? categoryId;
  double? amount;
  String? type, description;
  bool? favorite;
  DateTime? date;
  Category? category;

  TransactionModel({
    this.categoryId,
    this.amount,
    this.type,
    this.description,
    this.date,
    this.favorite,
    this.category,
  });

  @override
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  factory TransactionModel.fromJson(Map<String, dynamic> map) =>
      _$TransactionFromJson(map);

  static Map<String, String> getFields() {
    return {
      'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
      'amount': 'REAL',
      'type': 'TEXT',
      'description': 'TEXT',
      'categoryId': 'INT',
      'favorite': 'INT',
      'date': 'TEXT'
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    TransactionModel trx = _$TransactionFromJson(map);
    id = trx.id;
    amount = trx.amount;
    type = trx.type;
    description = trx.description;
    favorite = trx.favorite;
    categoryId = trx.categoryId;
    date = trx.date;
  }
}
