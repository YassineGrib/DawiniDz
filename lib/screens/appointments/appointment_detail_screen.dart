import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/appointment.dart';
import '../../models/doctor.dart';
import '../../services/appointment_service.dart';
import '../../utils/ui_helpers.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;
  final Doctor doctor;

  const AppointmentDetailScreen({
    super.key,
    required this.appointment,
    required this.doctor,
  });

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = widget.appointment.appointmentDate.isAfter(DateTime.now());
    final statusColor = _getStatusColor(widget.appointment.status);
    final statusText = _getStatusText(widget.appointment.status);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'تفاصيل الموعد',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingSmall),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                      ),
                      child: Icon(
                        _getStatusIcon(widget.appointment.status),
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'حالة الموعد',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: AppConstants.textSecondaryColor,
                            ),
                          ),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeLarge,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Doctor Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
                          child: Text(
                            widget.doctor.fullName.split(' ').first.substring(0, 1),
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeXLarge,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.doctor.fullName,
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeLarge,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.textPrimaryColor,
                                ),
                              ),
                              Text(
                                widget.doctor.specialty,
                                style: const TextStyle(
                                  fontSize: AppConstants.fontSizeMedium,
                                  color: AppConstants.textSecondaryColor,
                                ),
                              ),
                              if (widget.doctor.rating > 0) ...[
                                const SizedBox(height: AppConstants.paddingSmall / 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: AppConstants.warningColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: AppConstants.paddingSmall / 2),
                                    Text(
                                      widget.doctor.rating.toStringAsFixed(1),
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
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    // Contact Information
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: 'الهاتف',
                      value: widget.doctor.phone,
                    ),
                    _buildInfoRow(
                      icon: Icons.location_on,
                      label: 'العنوان',
                      value: widget.doctor.address,
                    ),
                    if (widget.doctor.consultationFee != null)
                      _buildInfoRow(
                        icon: Icons.payments,
                        label: 'رسوم الاستشارة',
                        value: '${widget.doctor.consultationFee!.toStringAsFixed(0)} دج',
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Appointment Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تفاصيل الموعد',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textPrimaryColor,
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'التاريخ',
                      value: UIHelpers.formatDateArabic(widget.appointment.appointmentDate),
                    ),
                    _buildInfoRow(
                      icon: Icons.access_time,
                      label: 'الوقت',
                      value: widget.appointment.appointmentTime,
                    ),
                    _buildInfoRow(
                      icon: Icons.event_note,
                      label: 'تاريخ الحجز',
                      value: UIHelpers.formatDateArabic(widget.appointment.createdAt),
                    ),
                    
                    if (widget.appointment.notes?.isNotEmpty == true) ...[
                      const SizedBox(height: AppConstants.paddingMedium),
                      const Text(
                        'ملاحظات',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                        ),
                        child: Text(
                          widget.appointment.notes!,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),

            // Action Buttons
            if (isUpcoming && widget.appointment.status == AppointmentStatus.scheduled) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : () => _rescheduleAppointment(),
                      icon: const Icon(Icons.edit_calendar),
                      label: const Text('إعادة جدولة'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.warningColor,
                        side: const BorderSide(color: AppConstants.warningColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _cancelAppointment(),
                      icon: const Icon(Icons.cancel),
                      label: const Text('إلغاء الموعد'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.errorColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppConstants.textSecondaryColor,
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  IconData _getStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Icons.schedule;
      case AppointmentStatus.confirmed:
        return Icons.check_circle;
      case AppointmentStatus.completed:
        return Icons.task_alt;
      case AppointmentStatus.cancelled:
        return Icons.cancel;
      case AppointmentStatus.rescheduled:
        return Icons.update;
    }
  }

  Future<void> _rescheduleAppointment() async {
    // TODO: Implement reschedule functionality
    UIHelpers.showWarningSnackBar(context, 'ميزة إعادة الجدولة قيد التطوير');
  }

  Future<void> _cancelAppointment() async {
    final confirmed = await UIHelpers.showConfirmationDialog(
      context,
      title: 'إلغاء الموعد',
      message: 'هل أنت متأكد من إلغاء هذا الموعد؟\nلن تتمكن من التراجع عن هذا الإجراء.',
      confirmText: 'إلغاء الموعد',
      confirmColor: AppConstants.errorColor,
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updatedAppointment = widget.appointment.copyWith(
          status: AppointmentStatus.cancelled,
        );
        
        await _appointmentService.updateAppointment(updatedAppointment);
        
        if (mounted) {
          UIHelpers.showSuccessSnackBar(context, 'تم إلغاء الموعد بنجاح');
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          UIHelpers.showErrorSnackBar(context, 'خطأ في إلغاء الموعد: ${e.toString()}');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
