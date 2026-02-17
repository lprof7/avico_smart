import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/auth_service.dart';

/// Auth Controller - Handles login flow
class AuthController extends GetxController {
  late final AuthRepository _authRepository;

  // Form Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable states
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    _authRepository = AuthRepository(authService: AuthService());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'invalid_email'.tr;
    }
    if (!GetUtils.isEmail(value)) {
      return 'invalid_email'.tr;
    }
    return null;
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr;
    }
    if (value.length < 6) {
      return 'password_too_short'.tr;
    }
    return null;
  }

  /// Login with email and password
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Show success message
      Get.snackbar(
        'success'.tr,
        'login_success'.tr,
        backgroundColor: AppColors.success.withValues(alpha: 0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      // Navigate to main screen
      Get.offAllNamed(AppRoutes.main);
    } on AuthException catch (e) {
      _showErrorSnackbar(e.message);
    } catch (e) {
      _showErrorSnackbar('login_error'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'error'.tr,
      message,
      backgroundColor: AppColors.error.withValues(alpha: 0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }
}
