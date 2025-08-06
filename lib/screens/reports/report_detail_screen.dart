import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/health_report.dart';

class ReportDetailScreen extends StatelessWidget {
  final HealthReport report;

  const ReportDetailScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'تفاصيل التقرير',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                          ),
                          child: const Icon(
                            Icons.description,
                            color: AppConstants.primaryColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.reportTitle,
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeXLarge,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppConstants.paddingSmall),
                              Text(
                                'د. ${report.doctorId}', // TODO: Get doctor name
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeMedium,
                                  color: AppConstants.primaryColor,
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
                              'تاريخ التقرير',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                color: AppConstants.textSecondaryColor,
                              ),
                            ),
                            Text(
                              '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (report.nextCheckupDate != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'الفحص القادم',
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeSmall,
                                  color: AppConstants.textSecondaryColor,
                                ),
                              ),
                              Text(
                                '${report.nextCheckupDate!.day}/${report.nextCheckupDate!.month}/${report.nextCheckupDate!.year}',
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeMedium,
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.warningColor,
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
            
            // Interpretation
            _buildSectionCard(
              title: 'التفسير الطبي',
              icon: Icons.analytics,
              content: report.interpretation,
              color: AppConstants.primaryColor,
            ),
            
            // Medical Notes
            if (report.medicalNotes != null && report.medicalNotes!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSectionCard(
                title: 'الملاحظات الطبية',
                icon: Icons.note_alt,
                content: report.medicalNotes!,
                color: AppConstants.secondaryColor,
              ),
            ],
            
            // Nutrition Advice
            if (report.nutritionAdvice != null && report.nutritionAdvice!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSectionCard(
                title: 'نصائح التغذية',
                icon: Icons.restaurant,
                content: report.nutritionAdvice!,
                color: AppConstants.successColor,
              ),
            ],
            
            // Activity Advice
            if (report.activityAdvice != null && report.activityAdvice!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSectionCard(
                title: 'نصائح النشاط البدني',
                icon: Icons.fitness_center,
                content: report.activityAdvice!,
                color: AppConstants.accentColor,
              ),
            ],
            
            // Treatment Modifications
            if (report.treatmentModifications != null && report.treatmentModifications!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSectionCard(
                title: 'تعديلات العلاج',
                icon: Icons.medical_services,
                content: report.treatmentModifications!,
                color: AppConstants.warningColor,
              ),
            ],
            
            // Next Checkup Reminder
            if (report.nextCheckupDate != null) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              Card(
                color: AppConstants.warningColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: AppConstants.warningColor,
                        size: 24,
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تذكير بالفحص القادم',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.warningColor,
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingSmall / 2),
                            Text(
                              'موعد الفحص القادم: ${report.nextCheckupDate!.day}/${report.nextCheckupDate!.month}/${report.nextCheckupDate!.year}',
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeSmall,
                                color: AppConstants.textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement appointment booking
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ميزة حجز الموعد قيد التطوير'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.warningColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('حجز موعد'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ميزة المشاركة قيد التطوير'),
                    ),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('مشاركة'),
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement download/print functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ميزة التحميل قيد التطوير'),
                    ),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('تحميل'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required String content,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textPrimaryColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
