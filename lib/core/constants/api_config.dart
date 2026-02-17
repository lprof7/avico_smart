/// API Configuration for Blynk IoT Platform
class ApiConfig {
  ApiConfig._();

  /// Blynk Cloud Base URL
  static const String blynkBaseUrl = 'https://blynk.cloud/external/api';

  /// Blynk Authentication Token
  static const String blynkToken = 'YOUR_BLYNK_TOKEN';

  /// Virtual Pins Mapping
  static const String temperaturePin = 'v1';
  static const String humidityPin = 'v2';
  static const String co2Pin = 'v3';
  static const String nitrogenPin = 'v4';

  /// Data Refresh Interval in seconds
  static const int refreshIntervalSeconds = 20;

  /// Build URL for getting a single pin value
  static String getPinUrl(String pin) {
    return '$blynkBaseUrl/get?token=$blynkToken&$pin';
  }

  /// Build URL for getting multiple pin values
  static String getMultiplePinsUrl(List<String> pins) {
    final pinsQuery = pins.join('&');
    return '$blynkBaseUrl/get?token=$blynkToken&$pinsQuery';
  }
}
