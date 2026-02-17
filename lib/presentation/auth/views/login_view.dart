import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

/// Login View - Firebase Authentication Screen
class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.backgroundGradientDark
              : AppColors.backgroundGradientLight,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo/Icon
                _buildLogo(),

                const SizedBox(height: 40),

                // Welcome Text
                _buildWelcomeText(isDark),

                const SizedBox(height: 40),

                // Login Form
                _buildLoginForm(isDark),

                const SizedBox(height: 32),

                // Login Button
                _buildLoginButton(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.warehouse_rounded,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildWelcomeText(bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Text(
            'welcome_back'.tr,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'login_subtitle'.tr,
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(bool isDark) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : AppColors.primary.withValues(alpha: 0.1),
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Email Field
              CustomTextField(
                controller: controller.emailController,
                labelText: 'email'.tr,
                hintText: 'email_hint'.tr,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: controller.validateEmail,
              ),

              const SizedBox(height: 20),

              // Password Field
              Obx(
                () => CustomTextField(
                  controller: controller.passwordController,
                  labelText: 'password'.tr,
                  hintText: 'password_hint'.tr,
                  prefixIcon: Icons.lock_outline,
                  obscureText: controller.obscurePassword.value,
                  textInputAction: TextInputAction.done,
                  validator: controller.validatePassword,
                  onSubmitted: (_) => controller.login(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondaryLight,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Obx(
        () => CustomButton(
          text: controller.isLoading.value
              ? 'logging_in'.tr
              : 'login_button'.tr,
          onPressed: controller.login,
          isLoading: controller.isLoading.value,
          width: double.infinity,
        ),
      ),
    );
  }
}
