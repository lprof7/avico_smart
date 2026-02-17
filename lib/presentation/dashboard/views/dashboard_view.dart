import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/hangar_model.dart';
import '../controllers/dashboard_controller.dart';

/// Dashboard View - Profile card and Hangars list
class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

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
                // Profile Card
                SliverToBoxAdapter(child: _buildProfileCard(isDark)),

                // Hangars Header
                SliverToBoxAdapter(child: _buildHangarsHeader(isDark)),

                // Hangars Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: _buildHangarsGrid(isDark),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipOval(
                child: Obx(
                  () => Image.asset(
                    controller.currentUser.value.profileImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white.withValues(alpha: 0.2),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'welcome_back'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.currentUser.value.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Settings Icon
            IconButton(
              onPressed: () => Get.toNamed('/settings'),
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHangarsHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'hangars'.tr,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : IconButton(
                    onPressed: controller.refresh,
                    icon: Icon(Icons.refresh_rounded, color: AppColors.primary),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHangarsGrid(bool isDark) {
    return Obx(() {
      if (controller.hangars.isEmpty && controller.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final hangar = controller.hangars[index];
          return _buildHangarCard(hangar, isDark);
        }, childCount: controller.hangars.length),
      );
    });
  }

  Widget _buildHangarCard(HangarModel hangar, bool isDark) {
    return GestureDetector(
      onTap: () => controller.openHangarDetails(hangar),
      child: Container(
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
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.warehouse_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hangar.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: hangar.isRealData
                                    ? AppColors.success
                                    : AppColors.warning,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              hangar.isRealData
                                  ? 'live_data'.tr
                                  : 'simulated'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  size: 18,
                ),
              ],
            ),

            const Spacer(),

            // Sensor Data Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSensorSummary(
                  icon: Icons.thermostat_rounded,
                  value:
                      '${hangar.sensorData.temperature.toStringAsFixed(1)}°C',
                  label: 'temperature'.tr,
                  color: _getTemperatureColor(hangar.sensorData.temperature),
                  isDark: isDark,
                ),
                _buildSensorSummary(
                  icon: Icons.water_drop_rounded,
                  value: '${hangar.sensorData.humidity.toStringAsFixed(0)}%',
                  label: 'humidity'.tr,
                  color: AppColors.info,
                  isDark: isDark,
                ),
                _buildSensorSummary(
                  icon: Icons.cloud_rounded,
                  value: '${hangar.sensorData.co2.toStringAsFixed(0)}',
                  label: 'CO₂',
                  color: AppColors.warning,
                  isDark: isDark,
                ),
                _buildSensorSummary(
                  icon: Icons.air_rounded,
                  value: '${hangar.sensorData.nitrogen.toStringAsFixed(0)}',
                  label: 'NH₃',
                  color: AppColors.secondary,
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorSummary({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Color _getTemperatureColor(double temp) {
    if (temp < 30) return AppColors.info;
    if (temp <= 38) return AppColors.success;
    return AppColors.error;
  }
}
