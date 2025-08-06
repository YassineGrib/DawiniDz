import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../services/appointment_service.dart';
import '../../services/doctor_service.dart';
import '../../utils/ui_helpers.dart';
import 'appointment_detail_screen.dart';
import '../doctors/doctor_search_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  final AppointmentService _appointmentService = AppointmentService();
  final DoctorService _doctorService = DoctorService();

  late TabController _tabController;
  List<Appointment> _allAppointments = [];
  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _pastAppointments = [];
  Map<String, Doctor> _doctorsMap = {};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Get current user ID from auth service
      const userId = 'current_user_id';
      final appointments = await _appointmentService.getUserAppointments(
        userId,
      );
      final doctors = await _doctorService.getAvailableDoctors();

      // Create doctors map for quick lookup
      final doctorsMap = <String, Doctor>{};
      for (final doctor in doctors) {
        doctorsMap[doctor.uuid] = doctor;
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      setState(() {
        _allAppointments = appointments;
        _doctorsMap = doctorsMap;

        _upcomingAppointments = appointments.where((appointment) {
          final appointmentDate = DateTime(
            appointment.appointmentDate.year,
            appointment.appointmentDate.month,
            appointment.appointmentDate.day,
          );
          return appointmentDate.isAfter(today) ||
              appointmentDate.isAtSameMomentAs(today);
        }).toList();

        _pastAppointments = appointments.where((appointment) {
          final appointmentDate = DateTime(
            appointment.appointmentDate.year,
            appointment.appointmentDate.month,
            appointment.appointmentDate.day,
          );
          return appointmentDate.isBefore(today);
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        UIHelpers.showErrorSnackBar(
          context,
          'خطأ في تحميل المواعيد: ${e.toString()}',
        );
      }
    }
  }

  List<Appointment> _getFilteredAppointments(List<Appointment> appointments) {
    if (_searchQuery.isEmpty) return appointments;

    return appointments.where((appointment) {
      final doctor = _doctorsMap[appointment.doctorId];
      if (doctor == null) return false;

      return doctor.fullName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          doctor.specialty.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'المواعيد', showBackButton: false),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'البحث في المواعيد...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
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
              Tab(text: 'القادمة'),
              Tab(text: 'السابقة'),
            ],
          ),

          // Tab Views
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAppointmentsList(
                        _getFilteredAppointments(_allAppointments),
                      ),
                      _buildAppointmentsList(
                        _getFilteredAppointments(_upcomingAppointments),
                      ),
                      _buildAppointmentsList(
                        _getFilteredAppointments(_pastAppointments),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => const DoctorSearchScreen(),
                ),
              )
              .then((_) => _loadAppointments());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return UIHelpers.buildEmptyState(
        icon: Icons.calendar_today,
        title: 'لا توجد مواعيد',
        subtitle: _searchQuery.isNotEmpty
            ? 'لا توجد مواعيد تطابق البحث'
            : 'لم تقم بحجز أي مواعيد بعد',
        action: _searchQuery.isEmpty
            ? ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => const DoctorSearchScreen(),
                        ),
                      )
                      .then((_) => _loadAppointments());
                },
                icon: const Icon(Icons.add),
                label: const Text('حجز موعد جديد'),
              )
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          final doctor = _doctorsMap[appointment.doctorId];

          return _buildAppointmentCard(appointment, doctor);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, Doctor? doctor) {
    if (doctor == null) {
      return const SizedBox(); // Skip if doctor not found
    }

    final isUpcoming = appointment.appointmentDate.isAfter(DateTime.now());
    final statusColor = _getStatusColor(appointment.status);
    final statusText = _getStatusText(appointment.status);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => AppointmentDetailScreen(
                    appointment: appointment,
                    doctor: doctor,
                  ),
                ),
              )
              .then((_) => _loadAppointments());
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Doctor Avatar
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppConstants.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    child: Text(
                      doctor.fullName.split(' ').first.substring(0, 1),
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppConstants.paddingMedium),

                  // Doctor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.fullName,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimaryColor,
                          ),
                        ),
                        Text(
                          doctor.specialty,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: AppConstants.paddingSmall / 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall,
                      ),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Appointment Details
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Text(
                    UIHelpers.formatDateArabic(appointment.appointmentDate),
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Text(
                    appointment.appointmentTime,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),

              if (appointment.notes?.isNotEmpty == true) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  appointment.notes!,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Action Buttons for upcoming appointments
              if (isUpcoming &&
                  appointment.status == AppointmentStatus.scheduled) ...[
                const SizedBox(height: AppConstants.paddingMedium),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _rescheduleAppointment(appointment),
                        icon: const Icon(Icons.edit_calendar, size: 16),
                        label: const Text('إعادة جدولة'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstants.warningColor,
                          side: const BorderSide(
                            color: AppConstants.warningColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _cancelAppointment(appointment),
                        icon: const Icon(Icons.cancel, size: 16),
                        label: const Text('إلغاء'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstants.errorColor,
                          side: const BorderSide(
                            color: AppConstants.errorColor,
                          ),
                        ),
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

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return AppConstants.primaryColor;
      case AppointmentStatus.confirmed:
        return AppConstants.successColor;
      case AppointmentStatus.completed:
        return AppConstants.successColor;
      case AppointmentStatus.cancelled:
        return AppConstants.errorColor;
      case AppointmentStatus.rescheduled:
        return AppConstants.warningColor;
    }
  }

  String _getStatusText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'مجدول';
      case AppointmentStatus.confirmed:
        return 'مؤكد';
      case AppointmentStatus.completed:
        return 'مكتمل';
      case AppointmentStatus.cancelled:
        return 'ملغي';
      case AppointmentStatus.rescheduled:
        return 'معاد جدولته';
    }
  }

  Future<void> _rescheduleAppointment(Appointment appointment) async {
    // TODO: Implement reschedule functionality
    UIHelpers.showWarningSnackBar(context, 'ميزة إعادة الجدولة قيد التطوير');
  }

  Future<void> _cancelAppointment(Appointment appointment) async {
    final confirmed = await UIHelpers.showConfirmationDialog(
      context,
      title: 'إلغاء الموعد',
      message: 'هل أنت متأكد من إلغاء هذا الموعد؟',
      confirmText: 'إلغاء الموعد',
      confirmColor: AppConstants.errorColor,
    );

    if (confirmed == true) {
      try {
        final updatedAppointment = appointment.copyWith(
          status: AppointmentStatus.cancelled,
        );

        await _appointmentService.updateAppointment(updatedAppointment);
        await _loadAppointments();

        if (mounted) {
          UIHelpers.showSuccessSnackBar(context, 'تم إلغاء الموعد بنجاح');
        }
      } catch (e) {
        if (mounted) {
          UIHelpers.showErrorSnackBar(
            context,
            'خطأ في إلغاء الموعد: ${e.toString()}',
          );
        }
      }
    }
  }
}
