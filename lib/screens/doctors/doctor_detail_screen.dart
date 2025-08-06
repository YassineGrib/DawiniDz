import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/doctor.dart';
import '../appointments/book_appointment_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'تفاصيل الطبيب'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Doctor Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: const BoxDecoration(
                gradient: AppConstants.primaryGradient,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      doctor.fullName.split(' ').first.substring(0, 1),
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeHeading,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    doctor.fullName,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem(
                        icon: Icons.star,
                        value: doctor.rating.toStringAsFixed(1),
                        label: 'التقييم',
                      ),
                      const SizedBox(width: AppConstants.paddingLarge),
                      if (doctor.yearsExperience != null)
                        _buildStatItem(
                          icon: Icons.work,
                          value: '${doctor.yearsExperience}',
                          label: 'سنة خبرة',
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Doctor Information
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                children: [
                  // Contact Information
                  _buildInfoCard(
                    title: 'معلومات الاتصال',
                    icon: Icons.contact_phone,
                    children: [
                      if (doctor.phone.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.phone,
                          label: 'الهاتف',
                          value: doctor.phone,
                        ),
                      if (doctor.email != null && doctor.email!.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.email,
                          label: 'البريد الإلكتروني',
                          value: doctor.email!,
                        ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.paddingMedium),

                  // Location Information
                  _buildInfoCard(
                    title: 'العنوان',
                    icon: Icons.location_on,
                    children: [
                      _buildInfoRow(
                        icon: Icons.location_city,
                        label: 'الولاية',
                        value: doctor.wilaya,
                      ),
                      _buildInfoRow(
                        icon: Icons.location_on,
                        label: 'البلدية',
                        value: doctor.commune,
                      ),
                      _buildInfoRow(
                        icon: Icons.home,
                        label: 'العنوان',
                        value: doctor.address,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.paddingMedium),

                  // Professional Information
                  _buildInfoCard(
                    title: 'المعلومات المهنية',
                    icon: Icons.medical_services,
                    children: [
                      _buildInfoRow(
                        icon: Icons.medical_services,
                        label: 'التخصص',
                        value: doctor.specialty,
                      ),
                      if (doctor.consultationFee != null)
                        _buildInfoRow(
                          icon: Icons.payments,
                          label: 'رسوم الاستشارة',
                          value:
                              '${doctor.consultationFee!.toStringAsFixed(0)} دج',
                        ),
                      if (doctor.workingHours != null)
                        _buildInfoRow(
                          icon: Icons.schedule,
                          label: 'ساعات العمل',
                          value: doctor.workingHours!,
                        ),
                      _buildInfoRow(
                        icon: Icons.check_circle,
                        label: 'الحالة',
                        value: doctor.isAvailable ? 'متاح' : 'غير متاح',
                        valueColor: doctor.isAvailable
                            ? AppConstants.successColor
                            : AppConstants.errorColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                  // TODO: Implement call functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ميزة الاتصال قيد التطوير')),
                  );
                },
                icon: const Icon(Icons.phone),
                label: const Text('اتصال'),
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: doctor.isAvailable
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                BookAppointmentScreen(doctor: doctor),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.calendar_today),
                label: const Text('حجز موعد'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: AppConstants.paddingSmall / 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingSmall / 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppConstants.primaryColor, size: 20),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppConstants.textSecondaryColor),
          const SizedBox(width: AppConstants.paddingSmall),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: valueColor ?? AppConstants.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
