import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Services
import '../../data/services/blynk_service.dart';
import '../../data/services/auth_service.dart';

// Repositories
import '../../data/repositories/sensor_repository.dart';
import '../../data/repositories/auth_repository.dart';

/// App Bindings - Initial Dependency Injection
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Shared Preferences (async initialization handled in main.dart)
    Get.lazyPut<SharedPreferences>(() => Get.find<SharedPreferences>());

    // Services
    Get.lazyPut<BlynkService>(() => BlynkService(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);

    // Repositories
    Get.lazyPut<SensorRepository>(
      () => SensorRepository(blynkService: Get.find<BlynkService>()),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(authService: Get.find<AuthService>()),
      fenix: true,
    );
  }
}
