import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routes/app_routes.dart';

/// Onboarding Controller - Handles onboarding flow and storage
class OnboardingController extends GetxController {
  static const String _onboardingKey = 'onboarding_completed';

  /// Check if onboarding should be shown
  static Future<bool> shouldShowOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_onboardingKey) ?? false);
  }

  /// Mark onboarding as completed and navigate to login
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      // Navigate anyway if storage fails
      Get.offAllNamed(AppRoutes.login);
    }
  }

  /// Get Started button pressed
  void onGetStarted() {
    completeOnboarding();
  }
}
