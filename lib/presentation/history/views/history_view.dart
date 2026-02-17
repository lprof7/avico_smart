import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/sensor_data_model.dart';
import '../controllers/history_controller.dart';

/// History View - Chart visualization of sensor history
class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.backgroundGradientDark
              : AppColors.backgroundGradientLight,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(isDark),

              // Sensor Type Selector
              _buildSensorSelector(isDark),

              const SizedBox(height: 16),

              // Chart
              Expanded(child: _buildChart(isDark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'history_title'.tr,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'last_24_hours'.tr,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorSelector(bool isDark) {
    return SizedBox(
      height: 50,
      child: Obx(
        () => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: SensorType.values.map((type) {
            final isSelected = controller.selectedSensorType.value == type;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildSelectorChip(type, isSelected, isDark),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSelectorChip(SensorType type, bool isSelected, bool isDark) {
    return GestureDetector(
      onTap: () => controller.selectSensorType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white),
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          type.translationKey.tr,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildChart(bool isDark) {
    return Obx(() {
      final data = controller.historicalData;
      final type = controller.selectedSensorType.value;

      if (data.isEmpty) {
        return Center(
          child: Text(
            'no_data'.tr,
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        );
      }

      final gradientColors = _getGradientColors(type);

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _getInterval(type),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: (isDark ? Colors.white : Colors.grey).withValues(
                      alpha: 0.1,
                    ),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 4,
                    getTitlesWidget: (value, meta) {
                      final hour = (24 - value.toInt()) % 24;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${hour}h',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            fontSize: 10,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: _getInterval(type),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 23,
              minY: type.gaugeRange.$1,
              maxY: type.gaugeRange.$2,
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) =>
                      isDark ? AppColors.cardDark : Colors.white,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${spot.y.toStringAsFixed(1)} ${type.unitKey.tr}',
                        TextStyle(
                          color: gradientColors.first,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.value))
                      .toList(),
                  isCurved: true,
                  curveSmoothness: 0.3,
                  gradient: LinearGradient(colors: gradientColors),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: gradientColors
                          .map((c) => c.withValues(alpha: 0.2))
                          .toList(),
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 500),
          ),
        ),
      );
    });
  }

  List<Color> _getGradientColors(SensorType type) {
    switch (type) {
      case SensorType.temperature:
        return [AppColors.secondary, AppColors.accent];
      case SensorType.humidity:
        return [AppColors.info, AppColors.primary];
      case SensorType.co2:
        return [AppColors.warning, AppColors.error];
      case SensorType.nitrogen:
        return [AppColors.primary, AppColors.success];
    }
  }

  double _getInterval(SensorType type) {
    switch (type) {
      case SensorType.temperature:
        return 10;
      case SensorType.humidity:
        return 20;
      case SensorType.co2:
        return 400;
      case SensorType.nitrogen:
        return 20;
    }
  }
}
