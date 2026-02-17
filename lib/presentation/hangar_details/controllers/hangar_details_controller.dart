import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../../data/models/hangar_model.dart';
import '../../../data/models/sensor_data_model.dart';
import '../../../data/fake_data.dart';
import '../../../data/services/blynk_service.dart';

/// Hangar Details Controller - Manages single hangar details and tabs
class HangarDetailsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final BlynkService _blynkService = BlynkService();
  final Random _random = Random();

  // Hangar data
  late Rx<HangarModel> hangar;

  // Tab index
  final RxInt currentTabIndex = 0.obs;

  // Food level management
  final RxDouble foodLevel = 0.0.obs;
  final double refillAmount = 25.0; // kg per refill

  // Zone temperatures
  final RxList<double> zoneTemperatures = <double>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isRefilling = false.obs;

  // History data
  final RxList<Map<String, dynamic>> historyData = <Map<String, dynamic>>[].obs;

  // Selected metric for heat map
  final RxString selectedMetric = 'temperature'.obs;

  // Timer for periodic updates
  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    // Get hangar from arguments
    final args = Get.arguments;
    if (args is HangarModel) {
      hangar = args.obs;
      foodLevel.value = args.foodLevel;
      zoneTemperatures.value = List<double>.from(args.zoneTemperatures);
    } else {
      // Fallback to empty hangar
      hangar = HangarModel(
        id: 'unknown',
        name: 'Unknown',
        sensorData: SensorDataModel.empty(),
      ).obs;
    }

    _loadData();

    // Refresh data every 20 seconds
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 20),
      (_) => _refreshData(),
    );
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    await Future.wait([_loadSensorData(), _loadHistoryData()]);
    isLoading.value = false;
  }

  Future<void> _loadSensorData() async {
    try {
      if (hangar.value.isRealData) {
        final sensorData = await _blynkService.fetchSensorData();
        hangar.value = hangar.value.copyWith(sensorData: sensorData);

        // Update zone temperatures with real data in zone 0
        _updateZoneTemperatures(sensorData.temperature);
      } else {
        // Use fake data
        final fakeData = FakeData.generateFakeSensorData();
        hangar.value = hangar.value.copyWith(sensorData: fakeData);
        _updateZoneTemperatures(null);
      }
    } catch (e) {
      // Keep existing data on error
    }
  }

  Future<void> _loadHistoryData() async {
    historyData.value = FakeData.generateHistoryData(24);
  }

  void _updateZoneTemperatures(double? realTemp) {
    final temps = <double>[];
    for (int i = 0; i < 8; i++) {
      if (i == 0 && realTemp != null) {
        temps.add(realTemp);
      } else {
        temps.add(25.0 + _random.nextDouble() * 17);
      }
    }
    zoneTemperatures.value = temps;
  }

  Future<void> _refreshData() async {
    await _loadSensorData();
  }

  /// Refill food level
  Future<void> refillFood() async {
    if (isRefilling.value) return;

    isRefilling.value = true;

    // Animate food refill
    final targetLevel = (foodLevel.value + refillAmount).clamp(
      0.0,
      hangar.value.maxFoodCapacity,
    );

    while (foodLevel.value < targetLevel) {
      await Future.delayed(const Duration(milliseconds: 50));
      foodLevel.value = (foodLevel.value + 1.0).clamp(
        0.0,
        hangar.value.maxFoodCapacity,
      );
    }

    // Update hangar model
    hangar.value = hangar.value.copyWith(foodLevel: foodLevel.value);
    isRefilling.value = false;
  }

  /// Consume food (called periodically to simulate consumption)
  void consumeFood(double amount) {
    foodLevel.value = (foodLevel.value - amount).clamp(
      0.0,
      hangar.value.maxFoodCapacity,
    );
    hangar.value = hangar.value.copyWith(foodLevel: foodLevel.value);
  }

  /// Change tab
  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  /// Get zone value by selected metric
  double getZoneValue(int index) {
    switch (selectedMetric.value) {
      case 'temperature':
        return zoneTemperatures[index];
      case 'humidity':
        return 40 + _random.nextDouble() * 40;
      case 'co2':
        return 300 + _random.nextDouble() * 700;
      case 'nh3':
        return 10 + _random.nextDouble() * 40;
      default:
        return zoneTemperatures[index];
    }
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _blynkService.dispose();
    super.onClose();
  }
}
