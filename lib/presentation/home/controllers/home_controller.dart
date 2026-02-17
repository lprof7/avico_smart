import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/sensor_data_model.dart';
import '../../../data/repositories/sensor_repository.dart';
import '../../../data/services/blynk_service.dart';

/// Home Controller - Manages sensor data fetching and state
class HomeController extends GetxController {
  late final SensorRepository _sensorRepository;
  Timer? _refreshTimer;

  // Observable states
  final sensorData = Rxn<SensorDataModel>();
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final lastUpdated = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    _sensorRepository = SensorRepository(blynkService: BlynkService());
    fetchSensorData();
    _startAutoRefresh();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _sensorRepository.dispose();
    super.onClose();
  }

  /// Start auto-refresh timer
  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      Duration(seconds: ApiConfig.refreshIntervalSeconds),
      (_) => fetchSensorData(),
    );
  }

  /// Fetch sensor data from Blynk
  Future<void> fetchSensorData({bool showLoading = false}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    hasError.value = false;
    errorMessage.value = '';

    try {
      final data = await _sensorRepository.getSensorData(forceRefresh: true);
      sensorData.value = data;
      lastUpdated.value = DateTime.now();
    } on BlynkException catch (e) {
      hasError.value = true;
      errorMessage.value = e.message;
      _showErrorSnackbar();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'fetch_error'.tr;
      _showErrorSnackbar();
    } finally {
      isLoading.value = false;
    }
  }

  /// Manual refresh
  Future<void> refresh() async {
    await fetchSensorData(showLoading: true);
  }

  /// Show error snackbar
  void _showErrorSnackbar() {
    Get.snackbar(
      'error'.tr,
      'fetch_error'.tr,
      backgroundColor: AppColors.error.withValues(alpha: 0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
    );
  }

  /// Get formatted last updated time
  String get formattedLastUpdated {
    if (lastUpdated.value == null) return '';
    final now = DateTime.now();
    final difference = now.difference(lastUpdated.value!);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else {
      return '${difference.inHours}h';
    }
  }
}
