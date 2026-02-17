import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Firebase Options
import 'firebase_options.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/localization/app_translations.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_pages.dart';
import 'core/bindings/app_bindings.dart';

// Controllers
import 'presentation/onboarding/controllers/onboarding_controller.dart';

// Repositories
import 'data/repositories/auth_repository.dart';
import 'data/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs);

  // Determine initial route
  final initialRoute = await _determineInitialRoute();

  runApp(AvicoSmartApp(initialRoute: initialRoute));
}

/// Determine the initial route based on onboarding and auth state
Future<String> _determineInitialRoute() async {
  // Check if onboarding was completed
  final shouldShowOnboarding =
      await OnboardingController.shouldShowOnboarding();
  if (shouldShowOnboarding) {
    return AppRoutes.onboarding;
  }

  // Check if user is logged in
  final authRepository = AuthRepository(authService: AuthService());
  if (authRepository.isLoggedIn) {
    return AppRoutes.main;
  }

  return AppRoutes.login;
}

/// Main App Widget
class AvicoSmartApp extends StatelessWidget {
  final String initialRoute;

  const AvicoSmartApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // App Title
      title: 'Avico Smart',

      // Debug Banner
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Localization
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),

      // Routing
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      initialBinding: AppBindings(),

      // Default Transition
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
