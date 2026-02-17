import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/hangar_details_controller.dart';

/// History Tab - Historical sensor data charts
class HistoryTab extends StatelessWidget {
  final HangarDetailsController controller;
  final bool isDark;

  const HistoryTab({super.key, required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Metric Selector
          _buildMetricSelector(),

          const SizedBox(height: 20),

          // Chart
          _buildChart(),

          const SizedBox(height: 20),

          // Stats Summary
          _buildStatsSummary(),
        ],
      ),
    );
  }

  Widget _buildMetricSelector() {
    final metrics = [
      {
        'key': 'temperature',
        'label': 'temperature'.tr,
        'icon': Icons.thermostat_rounded,
      },
      {
        'key': 'humidity',
        'label': 'humidity'.tr,
        'icon': Icons.water_drop_rounded,
      },
      {'key': 'co2', 'label': 'CO₂', 'icon': Icons.cloud_rounded},
      {'key': 'nitrogen', 'label': 'NH₃', 'icon': Icons.air_rounded},
    ];

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: metrics.map((metric) {
            final isSelected = controller.selectedMetric.value == metric['key'];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () =>
                    controller.selectedMetric.value = metric['key'] as String,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.cardDark : AppColors.cardLight),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        metric['icon'] as IconData,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        metric['label'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final data = controller.historyData;
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

        final selectedKey = controller.selectedMetric.value;
        final spots = data.asMap().entries.map((entry) {
          final value = (entry.value[selectedKey] as double?) ?? 0.0;
          return FlSpot(entry.key.toDouble(), value);
        }).toList();

        return LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _getInterval(selectedKey),
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.2),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
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
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 4,
                  getTitlesWidget: (value, meta) {
                    final hour = 24 - (data.length - 1 - value.toInt());
                    return Text(
                      '${hour}h',
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
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: _getMetricColor(selectedKey),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: _getMetricColor(selectedKey).withValues(alpha: 0.1),
                ),
              ),
            ],
            minY: _getMinY(selectedKey),
            maxY: _getMaxY(selectedKey),
          ),
        );
      }),
    );
  }

  Widget _buildStatsSummary() {
    return Obx(() {
      final data = controller.historyData;
      if (data.isEmpty) return const SizedBox();

      final selectedKey = controller.selectedMetric.value;
      final values = data
          .map((d) => (d[selectedKey] as double?) ?? 0.0)
          .toList();

      final avg = values.reduce((a, b) => a + b) / values.length;
      final max = values.reduce((a, b) => a > b ? a : b);
      final min = values.reduce((a, b) => a < b ? a : b);

      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'min'.tr,
              min.toStringAsFixed(1),
              AppColors.info,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'avg'.tr,
              avg.toStringAsFixed(1),
              AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'max'.tr,
              max.toStringAsFixed(1),
              AppColors.error,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMetricColor(String key) {
    switch (key) {
      case 'temperature':
        return AppColors.error;
      case 'humidity':
        return AppColors.info;
      case 'co2':
        return AppColors.warning;
      case 'nitrogen':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }

  double _getInterval(String key) {
    switch (key) {
      case 'temperature':
        return 10;
      case 'humidity':
        return 20;
      case 'co2':
        return 200;
      case 'nitrogen':
        return 20;
      default:
        return 10;
    }
  }

  double _getMinY(String key) {
    switch (key) {
      case 'temperature':
        return 0;
      case 'humidity':
        return 0;
      case 'co2':
        return 0;
      case 'nitrogen':
        return 0;
      default:
        return 0;
    }
  }

  double _getMaxY(String key) {
    switch (key) {
      case 'temperature':
        return 50;
      case 'humidity':
        return 100;
      case 'co2':
        return 2000;
      case 'nitrogen':
        return 100;
      default:
        return 100;
    }
  }
}
