import 'package:get/get.dart';
import '../../../data/models/hangar_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/sensor_data_model.dart';
import '../../../data/fake_data.dart';
import '../../../data/services/blynk_service.dart';

/// Dashboard Controller - Manages hangars list and user data
class DashboardController extends GetxController {
  final BlynkService _blynkService = BlynkService();

  // User data
  final Rx<UserModel> currentUser = FakeData.currentUser.obs;

  // Hangars list
  final RxList<HangarModel> hangars = <HangarModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Error state
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHangars();
  }

  /// Load hangars data (one real, one fake)
  Future<void> loadHangars() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Fetch real sensor data from Blynk for Hangar 1
      final realSensorData = await _blynkService.fetchSensorData();

      // Create Hangar 1 with real Blynk data
      final hangar1 = HangarModel(
        id: 'hangar_1',
        name: 'الحظيرة 1',
        sensorData: realSensorData,
        isRealData: true,
        foodLevel: 75.0,
        maxFoodCapacity: 100.0,
        zoneTemperatures: FakeData.generateZoneTemperatures(
          realSensorData.temperature,
        ),
      );

      // Get Hangar 2 with fake data
      final hangar2 = FakeData.fakeHangar;

      hangars.value = [hangar1, hangar2];
    } catch (e) {
      hasError.value = true;
      // Create hangars with fallback empty data
      hangars.value = [
        HangarModel(
          id: 'hangar_1',
          name: 'الحظيرة 1',
          sensorData: SensorDataModel.empty(),
          isRealData: true,
        ),
        FakeData.fakeHangar,
      ];
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh hangars data
  Future<void> refresh() async {
    await loadHangars();
  }

  /// Navigate to hangar details
  void openHangarDetails(HangarModel hangar) {
    Get.toNamed('/hangar-details', arguments: hangar);
  }

  @override
  void onClose() {
    _blynkService.dispose();
    super.onClose();
  }
}
