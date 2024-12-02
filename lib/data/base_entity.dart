import 'package:money_pocket_flow/models/index.dart';

abstract class BaseEntity {
  int? id; // Clave primaria autoincremental.

  // Convierte el objeto en un mapa.
  Map<String, dynamic> toJson();

  void fromMap(Map<String, dynamic> map);

  // Obtiene los campos de la clase como un mapa de nombres y tipos.
  static Map<String, String> getFields(Type type) {
    if (type == TransactionModel) {
      return TransactionModel.getFields();
    } else if (type == Settings) {
      return Settings.getFields();
    } else if (type == Category) {
      return Category.getFields();
    }
    throw UnimplementedError(
        'getFields debe ser implementado en cada entidad específica.');
  }
}
