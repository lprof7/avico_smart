import 'dart:math';
import 'models/hangar_model.dart';
import 'models/sensor_data_model.dart';
import 'models/user_model.dart';

/// Fake Data - Mock data for demonstration purposes
class FakeData {
  FakeData._();

  static final Random _random = Random();

  // ============ User Data ============
  static final UserModel currentUser = UserModel(
    name: 'محمد أحمد',
    email: 'mohamed@avico.com',
    profileImage: 'assets/images/profile.jpg',
  );

  // ============ Fake Sensor Data ============
  static SensorDataModel generateFakeSensorData() {
    return SensorDataModel(
      temperature: 25.0 + _random.nextDouble() * 15, // 25-40°C
      humidity: 40.0 + _random.nextDouble() * 40, // 40-80%
      co2: 300.0 + _random.nextDouble() * 700, // 300-1000 ppm
      nitrogen: 10.0 + _random.nextDouble() * 40, // 10-50 ppm
      timestamp: DateTime.now(),
    );
  }

  // ============ Fake Hangar Data ============
  static HangarModel get fakeHangar => HangarModel(
    id: 'hangar_2',
    name: 'الحظيرة 2',
    sensorData: generateFakeSensorData(),
    isRealData: false,
    foodLevel: 35.0 + _random.nextDouble() * 50,
    maxFoodCapacity: 100.0,
    zoneTemperatures: generateZoneTemperatures(null),
  );

  /// Generate zone temperatures for heat map
  /// One zone uses real temperature, others are random
  static List<double> generateZoneTemperatures(double? realTemperature) {
    final temps = <double>[];
    final realZoneIndex = 0; // First zone uses real data

    for (int i = 0; i < 8; i++) {
      if (i == realZoneIndex && realTemperature != null) {
        temps.add(realTemperature);
      } else {
        // Random temperature between 25-42°C
        temps.add(25.0 + _random.nextDouble() * 17);
      }
    }
    return temps;
  }

  // ============ History Data ============
  static List<Map<String, dynamic>> generateHistoryData(int hours) {
    final now = DateTime.now();
    return List.generate(hours, (i) {
      final time = now.subtract(Duration(hours: hours - 1 - i));
      return {
        'timestamp': time,
        'temperature': 25.0 + _random.nextDouble() * 15,
        'humidity': 40.0 + _random.nextDouble() * 40,
        'co2': 300.0 + _random.nextDouble() * 700,
        'nitrogen': 10.0 + _random.nextDouble() * 40,
      };
    });
  }
}
