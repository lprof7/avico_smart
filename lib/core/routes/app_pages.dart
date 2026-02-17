import 'package:get/get.dart';
import 'app_routes.dart';

// Import Views
import '../../presentation/onboarding/views/onboarding_view.dart';
import '../../presentation/auth/views/login_view.dart';
import '../../presentation/main/views/main_view.dart';
import '../../presentation/hangar_details/views/hangar_details_view.dart';
import '../../presentation/settings/views/settings_view.dart';

// Import Controllers
import '../../presentation/onboarding/controllers/onboarding_controller.dart';
import '../../presentation/auth/controllers/auth_controller.dart';
import '../../presentation/main/controllers/main_controller.dart';
import '../../presentation/home/controllers/home_controller.dart';
import '../../presentation/history/controllers/history_controller.dart';
import '../../presentation/settings/controllers/settings_controller.dart';
import '../../presentation/dashboard/controllers/dashboard_controller.dart';
import '../../presentation/hangar_details/controllers/hangar_details_controller.dart';

/// App Pages - GetX Page Configuration with Bindings
class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    // Onboarding Page
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OnboardingController>(() => OnboardingController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // Login Page
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // Main Page (Dashboard after login)
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MainController>(() => MainController());
        Get.lazyPut<DashboardController>(() => DashboardController());
        Get.lazyPut<HomeController>(() => HomeController());
        Get.lazyPut<HistoryController>(() => HistoryController());
        Get.lazyPut<SettingsController>(() => SettingsController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    // Hangar Details Page
    GetPage(
      name: AppRoutes.hangarDetails,
      page: () => const HangarDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HangarDetailsController>(() => HangarDetailsController());
      }),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Settings Page (standalone)
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SettingsController>(() => SettingsController());
      }),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
