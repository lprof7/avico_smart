import 'dart:math';
import 'package:get/get.dart';
import '../../../data/models/sensor_data_model.dart';

/// History Controller - Manages historical data display
class HistoryController extends GetxController {
  /// Currently selected sensor type for chart
  final selectedSensorType = SensorType.temperature.obs;

  /// Random historical data for the chart
  final historicalData = <HistoricalDataPoint>[].obs;

  /// Random instance for generating data
  final Random _random = Random();

  @override
  void onInit() {
    super.onInit();
    _generateRandomData();
  }

  /// Change selected sensor type
  void selectSensorType(SensorType type) {
    selectedSensorType.value = type;
    _generateRandomData();
  }

  /// Generate random historical data for demonstration
  void _generateRandomData() {
    final type = selectedSensorType.value;
    final range = type.gaugeRange;
    final normalRange = type.normalRange;

    historicalData.value = List.generate(24, (index) {
      // Generate value mostly within normal range with some variation
      final baseValue = (normalRange.$1 + normalRange.$2) / 2;
      final variation = (normalRange.$2 - normalRange.$1) * 0.5;
      final value = baseValue + (_random.nextDouble() - 0.5) * variation * 2;

      // Clamp to gauge range
      final clampedValue = value.clamp(range.$1, range.$2);

      return HistoricalDataPoint(
        timestamp: DateTime.now().subtract(Duration(hours: 23 - index)),
        value: clampedValue,
      );
    });
  }

  /// Refresh data
  void refreshData() {
    _generateRandomData();
  }
}

/// Historical data point model
class HistoricalDataPoint {
  final DateTime timestamp;
  final double value;

  HistoricalDataPoint({required this.timestamp, required this.value});
}
