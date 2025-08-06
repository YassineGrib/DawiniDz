import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/medical_measurement.dart';
import '../../services/medical_measurement_service.dart';

class MeasurementDetailScreen extends StatelessWidget {
  final MedicalMeasurement measurement;

  const MeasurementDetailScreen({
    super.key,
    required this.measurement,
  });

  @override
  Widget build(BuildContext context) {
    final measurementService = MedicalMeasurementService();
    final analysis = measurementService.analyzeMeasurement(measurement);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'تفاصيل القياس',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Measurement Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: _getMeasurementTypeColor(measurement.measurementType)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                          ),
                          child: Icon(
                            _getMeasurementTypeIcon(measurement.measurementType),
                            color: _getMeasurementTypeColor(measurement.measurementType),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getMeasurementTypeName(measurement.measurementType),
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeXLarge,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppConstants.paddingSmall),
                              Text(
                                measurement.displayValue,
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeXXLarge,
                                  fontWeight: FontWeight.bold,
                                  color: _getMeasurementTypeColor(measurement.measurementType),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'التاريخ',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                color: AppConstants.textSecondaryColor,
                              ),
                            ),
                            Text(
                              '${measurement.measurementDate.day}/${measurement.measurementDate.month}/${measurement.measurementDate.year}',
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'الوقت',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                color: AppConstants.textSecondaryColor,
                              ),
                            ),
                            Text(
                              measurement.measurementTime,
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            // Detailed Values
            if (measurement.measurementType == MeasurementType.bloodPressure || 
                measurement.measurementType == MeasurementType.both) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.favorite, color: AppConstants.primaryColor),
                          SizedBox(width: AppConstants.paddingSmall),
                          Text(
                            'ضغط الدم',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      Row(
                        children: [
                          Expanded(
                            child: _buildValueCard(
                              'الانقباضي',
                              '${measurement.systolicPressure}',
                              'mmHg',
                              Icons.arrow_upward,
                              AppConstants.primaryColor,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                            child: _buildValueCard(
                              'الانبساطي',
                              '${measurement.diastolicPressure}',
                              'mmHg',
                              Icons.arrow_downward,
                              AppConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
            ],
            
            if (measurement.measurementType == MeasurementType.bloodSugar || 
                measurement.measurementType == MeasurementType.both) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.water_drop, color: AppConstants.accentColor),
                          SizedBox(width: AppConstants.paddingSmall),
                          Text(
                            'سكر الدم',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      _buildValueCard(
                        'مستوى السكر',
                        '${measurement.bloodSugarLevel}',
                        'mg/dL',
                        Icons.water_drop,
                        AppConstants.accentColor,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
            ],
            
            // Analysis Results
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          analysis['isNormal'] ? Icons.check_circle : Icons.warning,
                          color: analysis['isNormal'] ? AppConstants.successColor : AppConstants.warningColor,
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Text(
                          'تحليل القياس',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: analysis['isNormal'] ? AppConstants.successColor : AppConstants.warningColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    if (analysis['warnings'].isNotEmpty) ...[
                      const Text(
                        'تحذيرات:',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.errorColor,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      ...analysis['warnings'].map<Widget>((warning) => Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall / 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.warning,
                              size: 16,
                              color: AppConstants.errorColor,
                            ),
                            const SizedBox(width: AppConstants.paddingSmall),
                            Expanded(
                              child: Text(
                                warning,
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  color: AppConstants.errorColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: AppConstants.paddingMedium),
                    ],
                    
                    if (analysis['recommendations'].isNotEmpty) ...[
                      const Text(
                        'التوصيات:',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      ...analysis['recommendations'].map<Widget>((recommendation) => Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall / 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.lightbulb,
                              size: 16,
                              color: AppConstants.primaryColor,
                            ),
                            const SizedBox(width: AppConstants.paddingSmall),
                            Expanded(
                              child: Text(
                                recommendation,
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  color: AppConstants.textPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),
            
            // Notes
            if (measurement.notes != null && measurement.notes!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.note, color: AppConstants.textSecondaryColor),
                          SizedBox(width: AppConstants.paddingSmall),
                          Text(
                            'ملاحظات',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        measurement.notes!,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: AppConstants.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: AppConstants.textSecondaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall / 2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontFamily: 'Tajawal',
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondaryColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMeasurementTypeColor(MeasurementType type) {
    switch (type) {
      case MeasurementType.bloodPressure:
        return AppConstants.primaryColor;
      case MeasurementType.bloodSugar:
        return AppConstants.accentColor;
      case MeasurementType.both:
        return AppConstants.secondaryColor;
    }
  }

  IconData _getMeasurementTypeIcon(MeasurementType type) {
    switch (type) {
      case MeasurementType.bloodPressure:
        return Icons.favorite;
      case MeasurementType.bloodSugar:
        return Icons.water_drop;
      case MeasurementType.both:
        return Icons.monitor_heart;
    }
  }

  String _getMeasurementTypeName(MeasurementType type) {
    switch (type) {
      case MeasurementType.bloodPressure:
        return 'ضغط الدم';
      case MeasurementType.bloodSugar:
        return 'سكر الدم';
      case MeasurementType.both:
        return 'ضغط وسكر الدم';
    }
  }
}
