import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';

import '../models/category.dart';

class DonutChart extends StatelessWidget {
  final List<Category> categories;

  const DonutChart({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    double totalAmount =
        categories.fold(0, (sum, item) => sum + (item.amount ?? 0));

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 4,
          centerSpaceRadius: 60,
          sections: categories.map((category) {
            final percentage = ((category.amount ?? 0) / totalAmount) * 100;

            return PieChartSectionData(
              value: category.amount,
              title: "${category.name}(${percentage.toStringAsFixed(1)}%)",
              color: HexColor(category.color!),
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              showTitle: true,
            );
          }).toList(),
        ),
      ),
    );
  }
}
