import 'package:http/http.dart' as http;
import '../../core/constants/api_config.dart';
import '../models/sensor_data_model.dart';

/// Blynk Service - HTTP calls to Blynk IoT Platform
class BlynkService {
  final http.Client _client;

  BlynkService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch all sensor data from Blynk
  Future<SensorDataModel> fetchSensorData() async {
    try {
      // Fetch all pins in parallel
      final results = await Future.wait([
        _fetchPinValue(ApiConfig.temperaturePin),
        _fetchPinValue(ApiConfig.humidityPin),
        _fetchPinValue(ApiConfig.co2Pin),
        _fetchPinValue(ApiConfig.nitrogenPin),
      ]);

      return SensorDataModel.fromApiResponses(
        temperatureResponse: results[0],
        humidityResponse: results[1],
        co2Response: results[2],
        nitrogenResponse: results[3],
      );
    } catch (e) {
      throw BlynkException('Failed to fetch sensor data: $e');
    }
  }

  /// Fetch a single pin value
  Future<String> _fetchPinValue(String pin) async {
    try {
      final url = ApiConfig.getPinUrl(pin);
      final response = await _client
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw BlynkException(
          'API returned status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is BlynkException) rethrow;
      throw BlynkException('Network error: $e');
    }
  }

  /// Fetch a specific sensor type value
  Future<double> fetchSensorValue(SensorType sensorType) async {
    try {
      final response = await _fetchPinValue(sensorType.virtualPin);
      return SensorDataModel.parseValue(response);
    } catch (e) {
      throw BlynkException('Failed to fetch ${sensorType.name}: $e');
    }
  }

  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }
}

/// Custom exception for Blynk API errors
class BlynkException implements Exception {
  final String message;

  BlynkException(this.message);

  @override
  String toString() => 'BlynkException: $message';
}
