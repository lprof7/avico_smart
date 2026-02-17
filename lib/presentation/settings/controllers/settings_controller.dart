import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/auth_service.dart';

/// Settings Controller - Manages settings and logout
class SettingsController extends GetxController {
  late final AuthRepository _authRepository;

  /// Current language code
  final currentLanguage = 'en'.obs;

  /// Available languages
  final languages = [
    {'code': 'en_US', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'ar_DZ', 'name': 'العربية', 'flag': '🇩🇿'},
    {'code': 'fr_FR', 'name': 'Français', 'flag': '🇫🇷'},
  ];

  @override
  void onInit() {
    super.onInit();
    _authRepository = AuthRepository(authService: AuthService());
    _loadCurrentLanguage();
  }

  /// Load current language from GetX
  void _loadCurrentLanguage() {
    final locale = Get.locale;
    if (locale != null) {
      currentLanguage.value = '${locale.languageCode}_${locale.countryCode}';
    }
  }

  /// Change app language
  void changeLanguage(String localeCode) {
    final parts = localeCode.split('_');
    final locale = Locale(parts[0], parts.length > 1 ? parts[1] : '');
    Get.updateLocale(locale);
    currentLanguage.value = localeCode;
  }

  /// Show logout confirmation dialog
  void showLogoutConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('logout'.tr),
        content: Text('logout_confirm'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _logout();
            },
            child: Text('confirm'.tr),
          ),
        ],
      ),
    );
  }

  /// Logout and navigate to login
  Future<void> _logout() async {
    try {
      await _authRepository.logout();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'unknown_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
