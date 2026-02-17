/// Hangar Model - Represents a poultry hangar with sensor data
import 'sensor_data_model.dart';

class HangarModel {
  /// Unique identifier
  final String id;

  /// Name of the hangar
  final String name;

  /// Sensor data (temperature, humidity, CO2, NH3)
  final SensorDataModel sensorData;

  /// Whether this hangar uses real Blynk data
  final bool isRealData;

  /// Food level in kg (0-100)
  final double foodLevel;

  /// Maximum food capacity in kg
  final double maxFoodCapacity;

  /// Zone temperatures for heat map (8 zones)
  final List<double> zoneTemperatures;

  HangarModel({
    required this.id,
    required this.name,
    required this.sensorData,
    this.isRealData = false,
    this.foodLevel = 50.0,
    this.maxFoodCapacity = 100.0,
    List<double>? zoneTemperatures,
  }) : zoneTemperatures = zoneTemperatures ?? List.filled(8, 25.0);

  /// Copy with updated values
  HangarModel copyWith({
    String? id,
    String? name,
    SensorDataModel? sensorData,
    bool? isRealData,
    double? foodLevel,
    double? maxFoodCapacity,
    List<double>? zoneTemperatures,
  }) {
    return HangarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sensorData: sensorData ?? this.sensorData,
      isRealData: isRealData ?? this.isRealData,
      foodLevel: foodLevel ?? this.foodLevel,
      maxFoodCapacity: maxFoodCapacity ?? this.maxFoodCapacity,
      zoneTemperatures: zoneTemperatures ?? this.zoneTemperatures,
    );
  }

  /// Get food level percentage
  double get foodLevelPercentage => (foodLevel / maxFoodCapacity) * 100;

  /// Check if food level is low (below 20%)
  bool get isFoodLow => foodLevelPercentage < 20;
}
