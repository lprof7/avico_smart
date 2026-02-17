import 'package:flutter/material.dart';

/// App Color Palette - Modern & Premium Design
class AppColors {
  AppColors._();

  // ============ Primary Colors ============
  /// Deep Teal - Primary Brand Color
  static const Color primary = Color(0xFF0D7377);
  static const Color primaryLight = Color(0xFF14A3A8);
  static const Color primaryDark = Color(0xFF095456);

  // ============ Secondary Colors ============
  /// Coral Accent - Secondary Color
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryLight = Color(0xFFFF8E8E);
  static const Color secondaryDark = Color(0xFFE54545);

  // ============ Accent Colors ============
  /// Golden Yellow - Accent for highlights
  static const Color accent = Color(0xFFFFD93D);
  static const Color accentLight = Color(0xFFFFE566);
  static const Color accentDark = Color(0xFFE5C235);

  // ============ Background Colors ============
  static const Color backgroundLight = Color(0xFFF8FAFB);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // ============ Card Colors ============
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2D2D2D);

  // ============ Text Colors ============
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // ============ Status Colors ============
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ============ Gauge Colors ============
  /// Temperature Gauge Gradient
  static const List<Color> temperatureGradient = [
    Color(0xFF3B82F6), // Blue (cold)
    Color(0xFF10B981), // Green (normal)
    Color(0xFFF59E0B), // Yellow (warm)
    Color(0xFFEF4444), // Red (hot)
  ];

  /// Humidity Gauge Gradient
  static const List<Color> humidityGradient = [
    Color(0xFFF59E0B), // Yellow (dry)
    Color(0xFF10B981), // Green (normal)
    Color(0xFF3B82F6), // Blue (humid)
  ];

  /// CO2 Gauge Gradient
  static const List<Color> co2Gradient = [
    Color(0xFF10B981), // Green (safe)
    Color(0xFFF59E0B), // Yellow (moderate)
    Color(0xFFEF4444), // Red (dangerous)
  ];

  /// Nitrogen Gauge Gradient
  static const List<Color> nitrogenGradient = [
    Color(0xFF6366F1), // Indigo (low)
    Color(0xFF10B981), // Green (optimal)
    Color(0xFFEF4444), // Red (high)
  ];

  // ============ Glassmorphism Colors ============
  static Color glassWhite = Colors.white.withValues(alpha: 0.15);
  static Color glassBorder = Colors.white.withValues(alpha: 0.2);
  static Color glassBlur = Colors.white.withValues(alpha: 0.05);

  // ============ Gradient Definitions ============
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient backgroundGradientLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF0F9FA), Color(0xFFE8F4F5)],
  );

  static const LinearGradient backgroundGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  );

  static const LinearGradient cardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D2D44), Color(0xFF1F1F2E)],
  );
}
