import 'dart:ffi';

import 'package:objectbox/objectbox.dart';

@Entity()
class Settings {
  @Id()
  int id = 0;

  Double? currencySymbol;
  String? language;
  String? theme;
}
