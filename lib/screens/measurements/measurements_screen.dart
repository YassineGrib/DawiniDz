import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/medical_measurement.dart';
import '../../services/medical_measurement_service.dart';
import 'add_measurement_screen.dart';
import 'measurement_detail_screen.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MedicalMeasurementService _measurementService = MedicalMeasurementService();
  
  List<MedicalMeasurement> _allMeasurements = [];
  List<MedicalMeasurement> _bloodPressureMeasurements = [];
  List<MedicalMeasurement> _bloodSugarMeasurements = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMeasurements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMeasurements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Get current user ID from auth service
      const userId = 'current_user_id';
      final measurements = await _measurementService.getUserMeasurements(userId);
      
      setState(() {
        _allMeasurements = measurements;
        _bloodPressureMeasurements = measurements
            .where((m) => m.measurementType == MeasurementType.bloodPressure || 
                         m.measurementType == MeasurementType.both)
            .toList();
        _bloodSugarMeasurements = measurements
            .where((m) => m.measurementType == MeasurementType.bloodSugar || 
                         m.measurementType == MeasurementType.both)
            .toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل القياسات: ${e.toString()}'),
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
        title: 'القياسات الطبية',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMeasurements,
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Cards
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'إجمالي القياسات',
                    value: '${_allMeasurements.length}',
                    icon: Icons.monitor_heart,
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
          
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: AppConstants.primaryColor,
            unselectedLabelColor: AppConstants.textSecondaryColor,
            indicatorColor: AppConstants.primaryColor,
            tabs: const [
              Tab(text: 'الكل'),
              Tab(text: 'ضغط الدم'),
              Tab(text: 'سكر الدم'),
            ],
          ),
          
          // Tab Views
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMeasurementsList(_allMeasurements),
                      _buildMeasurementsList(_bloodPressureMeasurements),
                      _buildMeasurementsList(_bloodSugarMeasurements),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddMeasurementScreen(),
            ),
          );
          if (result == true) {
            _loadMeasurements();
          }
        },
        child: const Icon(Icons.add),
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

  Widget _buildMeasurementsList(List<MedicalMeasurement> measurements) {
    if (measurements.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.monitor_heart_outlined,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              'لا توجد قياسات',
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                color: AppConstants.textSecondaryColor,
              ),
            ),
            SizedBox(height: AppConstants.paddingSmall),
            Text(
              'اضغط على + لإضافة قياس جديد',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: measurements.length,
      itemBuilder: (context, index) {
        final measurement = measurements[index];
        return _buildMeasurementCard(measurement);
      },
    );
  }

  Widget _buildMeasurementCard(MedicalMeasurement measurement) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MeasurementDetailScreen(measurement: measurement),
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
                      color: _getMeasurementTypeColor(measurement.measurementType)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                    ),
                    child: Icon(
                      _getMeasurementTypeIcon(measurement.measurementType),
                      color: _getMeasurementTypeColor(measurement.measurementType),
                      size: 20,
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
                            fontSize: AppConstants.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall / 2),
                        Text(
                          measurement.displayValue,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: _getMeasurementTypeColor(measurement.measurementType),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${measurement.measurementDate.day}/${measurement.measurementDate.month}/${measurement.measurementDate.year}',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall / 2),
                      Text(
                        measurement.measurementTime,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (measurement.notes != null && measurement.notes!.isNotEmpty) ...[
                const SizedBox(height: AppConstants.paddingMedium),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                  ),
                  child: Text(
                    measurement.notes!,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
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

  int _getThisMonthCount() {
    final now = DateTime.now();
    return _allMeasurements.where((measurement) {
      return measurement.measurementDate.year == now.year &&
             measurement.measurementDate.month == now.month;
    }).length;
  }
}
