/// Sensor Data Model - Represents warehouse environment readings
class SensorDataModel {
  /// Temperature in Celsius (from V1)
  final double temperature;

  /// Humidity percentage (from V2)
  final double humidity;

  /// CO2 concentration in ppm (from V3)
  final double co2;

  /// Nitrogen concentration in ppm (from V4)
  final double nitrogen;

  /// Timestamp of the reading
  final DateTime timestamp;

  SensorDataModel({
    required this.temperature,
    required this.humidity,
    required this.co2,
    required this.nitrogen,
    required this.timestamp,
  });

  /// Create from individual API responses
  factory SensorDataModel.fromApiResponses({
    required String temperatureResponse,
    required String humidityResponse,
    required String co2Response,
    required String nitrogenResponse,
  }) {
    return SensorDataModel(
      temperature: parseValue(temperatureResponse),
      humidity: parseValue(humidityResponse),
      co2: parseValue(co2Response),
      nitrogen: parseValue(nitrogenResponse),
      timestamp: DateTime.now(),
    );
  }

  /// Parse value from Blynk API response
  static double parseValue(String response) {
    try {
      // Blynk returns value in format: ["value"] or just a number
      String cleaned = response.replaceAll(RegExp(r'[\[\]"]'), '').trim();
      return double.tryParse(cleaned) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Create empty/default model
  factory SensorDataModel.empty() {
    return SensorDataModel(
      temperature: 0.0,
      humidity: 0.0,
      co2: 0.0,
      nitrogen: 0.0,
      timestamp: DateTime.now(),
    );
  }

  /// Copy with updated values
  SensorDataModel copyWith({
    double? temperature,
    double? humidity,
    double? co2,
    double? nitrogen,
    DateTime? timestamp,
  }) {
    return SensorDataModel(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      co2: co2 ?? this.co2,
      nitrogen: nitrogen ?? this.nitrogen,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'SensorDataModel('
        'temperature: $temperature, '
        'humidity: $humidity, '
        'co2: $co2, '
        'nitrogen: $nitrogen, '
        'timestamp: $timestamp)';
  }
}

/// Enum for sensor types
enum SensorType { temperature, humidity, co2, nitrogen }

/// Extension for sensor type utilities
extension SensorTypeExtension on SensorType {
  /// Get the virtual pin for this sensor type
  String get virtualPin {
    switch (this) {
      case SensorType.temperature:
        return 'v1';
      case SensorType.humidity:
        return 'v2';
      case SensorType.co2:
        return 'v3';
      case SensorType.nitrogen:
        return 'v4';
    }
  }

  /// Get the translation key for this sensor type
  String get translationKey {
    switch (this) {
      case SensorType.temperature:
        return 'temperature';
      case SensorType.humidity:
        return 'humidity';
      case SensorType.co2:
        return 'co2_level';
      case SensorType.nitrogen:
        return 'nitrogen_level';
    }
  }

  /// Get the unit translation key for this sensor type
  String get unitKey {
    switch (this) {
      case SensorType.temperature:
        return 'unit_celsius';
      case SensorType.humidity:
        return 'unit_percent';
      case SensorType.co2:
        return 'unit_ppm';
      case SensorType.nitrogen:
        return 'unit_ppm';
    }
  }

  /// Get the normal range for this sensor type
  (double min, double max) get normalRange {
    switch (this) {
      case SensorType.temperature:
        return (15.0, 30.0);
      case SensorType.humidity:
        return (40.0, 70.0);
      case SensorType.co2:
        return (0.0, 1000.0);
      case SensorType.nitrogen:
        return (0.0, 50.0);
    }
  }

  /// Get the gauge range for this sensor type
  (double min, double max) get gaugeRange {
    switch (this) {
      case SensorType.temperature:
        return (0.0, 50.0);
      case SensorType.humidity:
        return (0.0, 100.0);
      case SensorType.co2:
        return (0.0, 2000.0);
      case SensorType.nitrogen:
        return (0.0, 100.0);
    }
  }
}
