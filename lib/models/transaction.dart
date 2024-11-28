import 'package:json_annotation/json_annotation.dart';
import 'package:money_pocket_flow/data/base_entity.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction extends BaseEntity {
  int? categoryId;
  double? amount;
  String? type, description;
  bool? favorite;
  DateTime? date;

  Transaction(
      {this.categoryId,
      this.amount,
      this.type,
      this.description,
      this.date,
      this.favorite});

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  factory Transaction.fromJson(Map<String, dynamic> map) =>
      _$TransactionFromJson(map);

  static Map<String, String> getFields() {
    return {
      'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
      'amount': 'REAL',
      'type': 'TEXT',
      'description': 'TEXT',
      'favorite': 'INT',
      'date': 'TEXT'
    };
  }

  @override
  void fromMap(Map<String, dynamic> map) => _$TransactionFromJson(map);
}
