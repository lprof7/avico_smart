import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/hangar_details_controller.dart';
import '../widgets/status_tab.dart';
import '../widgets/history_tab.dart';
import '../widgets/heat_map_tab.dart';
import '../widgets/settings_tab.dart';

/// Hangar Details View - TabBar with Status, History, Heat Map, Settings
class HangarDetailsView extends GetView<HangarDetailsController> {
  const HangarDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: _buildAppBar(isDark),
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? AppColors.backgroundGradientDark
                : AppColors.backgroundGradientLight,
          ),
          child: TabBarView(
            children: [
              StatusTab(controller: controller, isDark: isDark),
              HistoryTab(controller: controller, isDark: isDark),
              HeatMapTab(controller: controller, isDark: isDark),
              SettingsTab(controller: controller, isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
        ),
      ),
      title: Obx(
        () => Text(
          controller.hangar.value.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
      ),
      centerTitle: true,
      bottom: TabBar(
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelColor: AppColors.primary,
        unselectedLabelColor: isDark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        tabs: [
          Tab(icon: const Icon(Icons.speed_rounded), text: 'nav_status'.tr),
          Tab(icon: const Icon(Icons.history_rounded), text: 'nav_history'.tr),
          Tab(icon: const Icon(Icons.grid_view_rounded), text: 'hangar_map'.tr),
          Tab(
            icon: const Icon(Icons.settings_rounded),
            text: 'nav_settings'.tr,
          ),
        ],
      ),
    );
  }
}
