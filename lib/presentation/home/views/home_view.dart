import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/sensor_data_model.dart';
import '../../shared/widgets/gauge_widget.dart';
import '../controllers/home_controller.dart';

/// Home View - Current Status Display with Gauges
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
          child: RefreshIndicator(
            onRefresh: controller.refresh,
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(child: _buildHeader(isDark)),

                // Gauges Grid
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: _buildGaugesGrid(isDark),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'current_status'.tr,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${'last_updated'.tr}: ${controller.formattedLastUpdated}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Refresh Button
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.refresh,
                icon: controller.isLoading.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : Icon(Icons.refresh_rounded, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugesGrid(bool isDark) {
    return Obx(() {
      final data = controller.sensorData.value;

      if (controller.isLoading.value && data == null) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'loading'.tr,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (data == null && controller.hasError.value) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 64,
                  color: AppColors.textSecondaryLight.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'fetch_error'.tr,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.refresh,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text('retry'.tr),
                ),
              ],
            ),
          ),
        );
      }

      final displayData = data ?? SensorDataModel.empty();

      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildListDelegate([
          // Temperature Gauge
          GaugeWidget(
            title: 'temperature'.tr,
            value: displayData.temperature,
            unit: 'unit_celsius'.tr,
            sensorType: SensorType.temperature,
            minValue: SensorType.temperature.gaugeRange.$1,
            maxValue: SensorType.temperature.gaugeRange.$2,
          ),

          // Humidity Gauge
          GaugeWidget(
            title: 'humidity'.tr,
            value: displayData.humidity,
            unit: 'unit_percent'.tr,
            sensorType: SensorType.humidity,
            minValue: SensorType.humidity.gaugeRange.$1,
            maxValue: SensorType.humidity.gaugeRange.$2,
          ),

          // CO2 Gauge
          GaugeWidget(
            title: 'co2_level'.tr,
            value: displayData.co2,
            unit: 'unit_ppm'.tr,
            sensorType: SensorType.co2,
            minValue: SensorType.co2.gaugeRange.$1,
            maxValue: SensorType.co2.gaugeRange.$2,
          ),

          // Nitrogen Gauge
          GaugeWidget(
            title: 'nitrogen_level'.tr,
            value: displayData.nitrogen,
            unit: 'unit_ppm'.tr,
            sensorType: SensorType.nitrogen,
            minValue: SensorType.nitrogen.gaugeRange.$1,
            maxValue: SensorType.nitrogen.gaugeRange.$2,
          ),
        ]),
      );
    });
  }
}
