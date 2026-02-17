import '../models/sensor_data_model.dart';
import '../services/blynk_service.dart';

/// Sensor Repository - Abstraction over Blynk Service
class SensorRepository {
  final BlynkService _blynkService;

  /// Cache for last fetched data
  SensorDataModel? _cachedData;
  DateTime? _lastFetchTime;

  /// Cache duration in seconds (don't fetch more often than this)
  static const int _cacheDurationSeconds = 5;

  SensorRepository({required BlynkService blynkService})
    : _blynkService = blynkService;

  /// Get current sensor data
  Future<SensorDataModel> getSensorData({bool forceRefresh = false}) async {
    // Return cached data if it's fresh enough and not forcing refresh
    if (!forceRefresh && _isCacheValid()) {
      return _cachedData!;
    }

    try {
      final data = await _blynkService.fetchSensorData();
      _cachedData = data;
      _lastFetchTime = DateTime.now();
      return data;
    } on BlynkException {
      // If we have cached data, return it on error
      if (_cachedData != null) {
        return _cachedData!;
      }
      rethrow;
    }
  }

  /// Get a specific sensor value
  Future<double> getSensorValue(SensorType sensorType) async {
    return _blynkService.fetchSensorValue(sensorType);
  }

  /// Get cached data if available
  SensorDataModel? get cachedData => _cachedData;

  /// Check if cache is still valid
  bool _isCacheValid() {
    if (_cachedData == null || _lastFetchTime == null) {
      return false;
    }

    final difference = DateTime.now().difference(_lastFetchTime!);
    return difference.inSeconds < _cacheDurationSeconds;
  }

  /// Clear cache
  void clearCache() {
    _cachedData = null;
    _lastFetchTime = null;
  }

  /// Dispose resources
  void dispose() {
    _blynkService.dispose();
  }
}
