import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/icon_map.dart';

String getNameByIcon(IconData icon) {
  String iconName =
      iconMap.entries.firstWhere((entry) => entry.value == icon).key;
  return iconName;
}
