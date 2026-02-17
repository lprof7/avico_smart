import 'package:get/get.dart';

/// Main Controller - Handles bottom navigation state
class MainController extends GetxController {
  /// Current selected tab index
  final currentIndex = 0.obs;

  /// Change current tab
  void changeTab(int index) {
    currentIndex.value = index;
  }

  /// Get if a specific tab is selected
  bool isSelected(int index) => currentIndex.value == index;
}
