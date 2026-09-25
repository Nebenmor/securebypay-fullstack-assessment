import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class GrowthChart extends StatelessWidget {
  final List<dynamic> labels;
  final List<dynamic> values;
  const GrowthChart({super.key, required this.labels, required this.values});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[
      for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), (values[i] as num).toDouble()),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.sidebarBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Company Growth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.08)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}