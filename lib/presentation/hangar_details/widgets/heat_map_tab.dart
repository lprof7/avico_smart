import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/hangar_details_controller.dart';

/// Heat Map Tab - 8-zone temperature grid
class HeatMapTab extends StatelessWidget {
  final HangarDetailsController controller;
  final bool isDark;

  const HeatMapTab({super.key, required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with metric selector
          _buildHeader(),

          const SizedBox(height: 16),

          // Heat Map Grid
          _buildHeatMapGrid(),

          const SizedBox(height: 20),

          // Legend
          _buildLegend(),

          const SizedBox(height: 20),

          // Zone Details
          _buildZoneDetails(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.grid_view_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'hangar_map'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          // Metric Selector Chips
          Obx(
            () => Row(
              children: [
                _buildMetricChip('Temp', 'temperature'),
                const SizedBox(width: 8),
                _buildMetricChip('Hum', 'humidity'),
                const SizedBox(width: 8),
                _buildMetricChip('CO₂', 'co2'),
                const SizedBox(width: 8),
                _buildMetricChip('NH₃', 'nh3'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String label, String key) {
    final isSelected = controller.selectedMetric.value == key;
    return GestureDetector(
      onTap: () => controller.selectedMetric.value = key,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent
              : (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? AppColors.textPrimaryLight
                : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
          ),
        ),
      ),
    );
  }

  Widget _buildHeatMapGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Obx(() => _buildZoneCell(index));
        },
      ),
    );
  }

  Widget _buildZoneCell(int index) {
    final value = controller.getZoneValue(index);
    final color = _getZoneColor(value, controller.selectedMetric.value);
    final isRealData = index == 0 && controller.hangar.value.isRealData;

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: isRealData
            ? Border.all(color: AppColors.accent, width: 3)
            : null,
      ),
      child: Stack(
        children: [
          // Zone indicator dot
          Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),

          // Value overlay
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _formatValue(value),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Real data badge
          if (isRealData)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.sensors_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'legend'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(Colors.blue, 'cold'.tr, '< 30°C'),
              _buildLegendItem(Colors.green, 'normal'.tr, '30-38°C'),
              _buildLegendItem(Colors.red, 'hot'.tr, '> 38°C'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, String range) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              range,
              style: TextStyle(
                fontSize: 10,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildZoneDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'zone_info'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'zone_info_desc'.tr,
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Color _getZoneColor(double value, String metric) {
    if (metric == 'temperature') {
      if (value < 30) return Colors.blue;
      if (value <= 38) return Colors.green;
      return Colors.red;
    } else if (metric == 'humidity') {
      if (value < 40) return Colors.orange;
      if (value <= 70) return Colors.green;
      return Colors.blue;
    } else if (metric == 'co2') {
      if (value < 600) return Colors.green;
      if (value <= 1000) return Colors.orange;
      return Colors.red;
    } else {
      // NH3
      if (value < 25) return Colors.green;
      if (value <= 50) return Colors.orange;
      return Colors.red;
    }
  }

  String _formatValue(double value) {
    final metric = controller.selectedMetric.value;
    switch (metric) {
      case 'temperature':
        return '${value.toStringAsFixed(1)}°C';
      case 'humidity':
        return '${value.toStringAsFixed(0)}%';
      case 'co2':
      case 'nh3':
        return '${value.toStringAsFixed(0)}ppm';
      default:
        return value.toStringAsFixed(1);
    }
  }
}
