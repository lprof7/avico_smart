import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/sensor_data_model.dart';
import '../../shared/widgets/gauge_widget.dart';
import '../controllers/hangar_details_controller.dart';

/// Status Tab - Sensor gauges and food level indicator
class StatusTab extends StatelessWidget {
  final HangarDetailsController controller;
  final bool isDark;

  const StatusTab({super.key, required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Level Card
          _buildFoodLevelCard(),

          const SizedBox(height: 20),

          // Sensor Gauges Header
          Text(
            'sensor_readings'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),

          const SizedBox(height: 12),

          // Sensor Gauges Grid
          _buildGaugesGrid(),
        ],
      ),
    );
  }

  Widget _buildFoodLevelCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: AppColors.accent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'food_level'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              Obx(() {
                final level = controller.foodLevel.value;
                final max = controller.hangar.value.maxFoodCapacity;
                return Text(
                  '${level.toStringAsFixed(1)} / ${max.toStringAsFixed(0)} ${'unit_kg'.tr}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
          Obx(() {
            final percentage =
                (controller.foodLevel.value /
                        controller.hangar.value.maxFoodCapacity)
                    .clamp(0.0, 1.0);
            final color = _getFoodLevelColor(percentage);

            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 20,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(percentage * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    if (percentage < 0.3)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_rounded,
                              color: AppColors.error,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'low_level'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            );
          }),

          const SizedBox(height: 16),

          // Refill Button
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isRefilling.value
                    ? null
                    : controller.refillFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.5,
                  ),
                ),
                icon: controller.isRefilling.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_circle_outline_rounded),
                label: Text(
                  controller.isRefilling.value
                      ? 'refilling'.tr
                      : 'refill'.tr +
                            ' (+${controller.refillAmount.toStringAsFixed(0)} ${'unit_kg'.tr})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugesGrid() {
    return Obx(() {
      final data = controller.hangar.value.sensorData;

      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GaugeWidget(
            title: 'temperature'.tr,
            value: data.temperature,
            unit: 'unit_celsius'.tr,
            sensorType: SensorType.temperature,
            minValue: SensorType.temperature.gaugeRange.$1,
            maxValue: SensorType.temperature.gaugeRange.$2,
          ),
          GaugeWidget(
            title: 'humidity'.tr,
            value: data.humidity,
            unit: 'unit_percent'.tr,
            sensorType: SensorType.humidity,
            minValue: SensorType.humidity.gaugeRange.$1,
            maxValue: SensorType.humidity.gaugeRange.$2,
          ),
          GaugeWidget(
            title: 'co2_level'.tr,
            value: data.co2,
            unit: 'unit_ppm'.tr,
            sensorType: SensorType.co2,
            minValue: SensorType.co2.gaugeRange.$1,
            maxValue: SensorType.co2.gaugeRange.$2,
          ),
          GaugeWidget(
            title: 'nitrogen_level'.tr,
            value: data.nitrogen,
            unit: 'unit_ppm'.tr,
            sensorType: SensorType.nitrogen,
            minValue: SensorType.nitrogen.gaugeRange.$1,
            maxValue: SensorType.nitrogen.gaugeRange.$2,
          ),
        ],
      );
    });
  }

  Color _getFoodLevelColor(double percentage) {
    if (percentage < 0.2) return AppColors.error;
    if (percentage < 0.5) return AppColors.warning;
    return AppColors.success;
  }
}
