import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:in_out/servicies/config_service.dart';
import 'package:in_out/utils/constants.dart';
import 'package:provider/provider.dart';

class MyLineChart extends StatelessWidget {
  const MyLineChart({
    Key? key,
    required this.spots,
    required this.oneInterval,
    required this.showNumbers,
    this.forceAsIncome,
  }) : super(key: key);
  final bool oneInterval;
  final bool showNumbers;
  final List<FlSpot> spots;
  final bool? forceAsIncome;

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigService>(context);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles()),
          rightTitles: const AxisTitles(sideTitles: SideTitles()),
          leftTitles: const AxisTitles(sideTitles: SideTitles()),
          bottomTitles: !showNumbers
              ? const AxisTitles(sideTitles: SideTitles())
              : AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: kBigSpace,
                    interval: oneInterval ? 1 : null,
                  ),
                ),
        ),
        lineBarsData: [
          LineChartBarData(
            color: forceAsIncome ?? config.isIncome ? kDarkGreen : kRed,
            barWidth: 1,
            curveSmoothness: .5,
            preventCurveOverShooting: true,
            isCurved: true,
            spots: spots,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: forceAsIncome ?? config.isIncome
                  ? kDarkGreen.withOpacity(.1)
                  : kRed.withOpacity(.1),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
}
