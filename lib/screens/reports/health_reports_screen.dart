import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/health_report.dart';
import '../../services/health_report_service.dart';
import 'report_detail_screen.dart';

class HealthReportsScreen extends StatefulWidget {
  const HealthReportsScreen({super.key});

  @override
  State<HealthReportsScreen> createState() => _HealthReportsScreenState();
}

class _HealthReportsScreenState extends State<HealthReportsScreen> {
  final HealthReportService _reportService = HealthReportService();
  List<HealthReport> _reports = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Get current user ID from auth service
      const userId = 'current_user_id';
      final reports = await _reportService.getUserReports(userId);
      
      setState(() {
        _reports = reports;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل التقارير: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'التقارير الصحية',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReports,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: AppConstants.textSecondaryColor,
                      ),
                      SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        'لا توجد تقارير صحية',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeLarge,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                      SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        'ستظهر التقارير هنا عندما يقوم الطبيب بإنشائها',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: AppConstants.textSecondaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Statistics
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'إجمالي التقارير',
                              value: '${_reports.length}',
                              icon: Icons.description,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Expanded(
                            child: _buildStatCard(
                              title: 'هذا الشهر',
                              value: '${_getThisMonthCount()}',
                              icon: Icons.calendar_month,
                              color: AppConstants.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Reports List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        itemCount: _reports.length,
                        itemBuilder: (context, index) {
                          final report = _reports[index];
                          return _buildReportCard(report);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(HealthReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReportDetailScreen(report: report),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: AppConstants.primaryColor,
                      size: 20,
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
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall / 2),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${report.createdAt.day}/${report.createdAt.month}/${report.createdAt.year}',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                      if (report.nextCheckupDate != null) ...[
                        const SizedBox(height: AppConstants.paddingSmall / 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingSmall,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.warningColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                          ),
                          child: Text(
                            'فحص قادم',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: AppConstants.warningColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              Text(
                report.interpretation,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textPrimaryColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              if (report.nextCheckupDate != null) ...[
                const SizedBox(height: AppConstants.paddingMedium),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: AppConstants.textSecondaryColor,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall / 2),
                    Text(
                      'الفحص القادم: ${report.nextCheckupDate!.day}/${report.nextCheckupDate!.month}/${report.nextCheckupDate!.year}',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  int _getThisMonthCount() {
    final now = DateTime.now();
    return _reports.where((report) {
      return report.createdAt.year == now.year &&
             report.createdAt.month == now.month;
    }).length;
  }
}
