import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/sensor_data_model.dart';

/// Beautiful Gauge Widget for displaying sensor values
class GaugeWidget extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final SensorType sensorType;
  final double minValue;
  final double maxValue;

  const GaugeWidget({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.sensorType,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = _getGradientColors();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.cardGradientDark : null,
        color: isDark ? null : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),

          // Gauge
          SizedBox(
            height: 140,
            child: SfRadialGauge(
              enableLoadingAnimation: true,
              animationDuration: 1500,
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: minValue,
                  maximum: maxValue,
                  startAngle: 150,
                  endAngle: 30,
                  showLabels: false,
                  showTicks: false,
                  radiusFactor: 0.95,
                  axisLineStyle: AxisLineStyle(
                    cornerStyle: CornerStyle.bothCurve,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.15),
                    thickness: 12,
                  ),
                  pointers: <GaugePointer>[
                    // Range pointer with gradient
                    RangePointer(
                      value: value,
                      cornerStyle: CornerStyle.bothCurve,
                      width: 12,
                      gradient: SweepGradient(colors: gradientColors),
                      enableAnimation: true,
                      animationDuration: 1200,
                      animationType: AnimationType.easeOutBack,
                    ),
                    // Needle pointer
                    NeedlePointer(
                      value: value,
                      needleLength: 0.6,
                      needleStartWidth: 1,
                      needleEndWidth: 4,
                      knobStyle: KnobStyle(
                        knobRadius: 0.08,
                        color: _getStatusColor(),
                        borderColor: isDark ? Colors.white : Colors.grey[300]!,
                        borderWidth: 2,
                      ),
                      needleColor: _getStatusColor(),
                      enableAnimation: true,
                      animationDuration: 1200,
                      animationType: AnimationType.easeOutBack,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    // Value display
                    GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.0,
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(),
                            ),
                          ),
                          Text(
                            unit,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status indicator
          _buildStatusChip(),
        ],
      ),
    );
  }

  /// Get gradient colors based on sensor type
  List<Color> _getGradientColors() {
    switch (sensorType) {
      case SensorType.temperature:
        return AppColors.temperatureGradient;
      case SensorType.humidity:
        return AppColors.humidityGradient;
      case SensorType.co2:
        return AppColors.co2Gradient;
      case SensorType.nitrogen:
        return AppColors.nitrogenGradient;
    }
  }

  /// Get status color based on value
  Color _getStatusColor() {
    final range = sensorType.normalRange;
    if (value < range.$1 * 0.8 || value > range.$2 * 1.2) {
      return AppColors.error;
    } else if (value < range.$1 || value > range.$2) {
      return AppColors.warning;
    }
    return AppColors.success;
  }

  /// Get status text based on value
  String _getStatusText() {
    final range = sensorType.normalRange;
    if (value < range.$1 * 0.8 || value > range.$2 * 1.2) {
      return 'Critical';
    } else if (value < range.$1 || value > range.$2) {
      return 'Warning';
    }
    return 'Normal';
  }

  /// Build status chip
  Widget _buildStatusChip() {
    final color = _getStatusColor();
    final text = _getStatusText();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
