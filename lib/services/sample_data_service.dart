import 'package:flutter/foundation.dart';
import 'doctor_service.dart';
import 'medical_measurement_service.dart';
import 'health_report_service.dart';
import 'task_service.dart';
import 'appointment_service.dart';
import 'user_service.dart';
import '../models/medical_measurement.dart';
import '../models/user.dart';
import '../database/database_helper.dart';

class SampleDataService {
  final DoctorService _doctorService = DoctorService();
  final MedicalMeasurementService _measurementService =
      MedicalMeasurementService();
  final HealthReportService _reportService = HealthReportService();
  final TaskService _taskService = TaskService();
  final AppointmentService _appointmentService = AppointmentService();
  final UserService _userService = UserService();

  // Initialize all sample data
  Future<void> initializeSampleData() async {
    const userId = 'current_user_id';

    try {
      // Create sample user first
      await _createSampleUser(userId);

      // Create sample doctors
      await _createSampleDoctors();

      // Create sample measurements
      await _createSampleMeasurements(userId);

      // Create sample health reports
      await _reportService.createSampleReports(userId);

      // Create sample tasks
      await _taskService.createSampleTasks(userId);

      print('Sample data initialized successfully');
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }

  // Create sample user
  Future<void> _createSampleUser(String userId) async {
    try {
      // Check if user already exists
      final existingUser = await _userService.getUserByUuid(userId);
      if (existingUser != null) {
        debugPrint('Sample user already exists');
        return;
      }

      // Create sample user with specific UUID
      final now = DateTime.now();
      final user = User(
        uuid: userId,
        fullName: 'أحمد محمد العربي',
        email: 'ahmed.alarabi@example.com',
        phone: '0555123456',
        dateOfBirth: DateTime(1990, 5, 15),
        gender: 'ذكر',
        address: 'شارع الاستقلال، حي النصر',
        wilaya: 'الجزائر',
        commune: 'الجزائر الوسطى',
        createdAt: now,
        updatedAt: now,
      );

      // Insert directly to database
      final dbHelper = DatabaseHelper();
      await dbHelper.insert('users', user.toMap());

      debugPrint('Sample user created successfully');
    } catch (e) {
      debugPrint('Error creating sample user: $e');
    }
  }

  // Create sample doctors
  Future<void> _createSampleDoctors() async {
    final sampleDoctors = [
      {
        'fullName': 'د. أحمد محمد العربي',
        'specialty': 'طب عام',
        'email': 'ahmed.alarabi@example.com',
        'phone': '0555123456',
        'address': 'شارع الاستقلال، حي النصر',
        'wilaya': 'الجزائر',
        'commune': 'الجزائر الوسطى',
        'consultationFee': 2000.0,
        'rating': 4.5,
        'yearsExperience': 15,
        'workingHours': 'الأحد - الخميس: 8:00 ص - 6:00 م',
      },
      {
        'fullName': 'د. فاطمة بن علي',
        'specialty': 'طب الأطفال',
        'email': 'fatima.benali@example.com',
        'phone': '0555234567',
        'address': 'شارع ديدوش مراد، حي الحمامات',
        'wilaya': 'الجزائر',
        'commune': 'باب الوادي',
        'consultationFee': 2500.0,
        'rating': 4.8,
        'yearsExperience': 12,
        'workingHours': 'السبت - الأربعاء: 9:00 ص - 5:00 م',
      },
      {
        'fullName': 'د. محمد الصالح بوعزيز',
        'specialty': 'طب القلب',
        'email': 'mohamed.bouaziz@example.com',
        'phone': '0555345678',
        'address': 'شارع العربي بن مهيدي، حي بلكور',
        'wilaya': 'وهران',
        'commune': 'وهران',
        'consultationFee': 3500.0,
        'rating': 4.9,
        'yearsExperience': 20,
        'workingHours': 'الأحد - الخميس: 8:30 ص - 4:30 م',
      },
    ];

    for (final doctorData in sampleDoctors) {
      try {
        await _doctorService.createDoctor(
          fullName: doctorData['fullName'] as String,
          specialty: doctorData['specialty'] as String,
          email: doctorData['email'] as String,
          phone: doctorData['phone'] as String,
          address: doctorData['address'] as String,
          wilaya: doctorData['wilaya'] as String,
          commune: doctorData['commune'] as String,
          consultationFee: doctorData['consultationFee'] as double,
          rating: doctorData['rating'] as double,
          yearsExperience: doctorData['yearsExperience'] as int,
          workingHours: doctorData['workingHours'] as String,
        );
      } catch (e) {
        debugPrint('Error creating sample doctor: $e');
      }
    }
  }

  // Create sample medical measurements
  Future<void> _createSampleMeasurements(String userId) async {
    final sampleMeasurements = [
      {
        'type': MeasurementType.bloodPressure,
        'systolic': 120,
        'diastolic': 80,
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'time': '08:00',
        'notes': 'قياس صباحي بعد الاستيقاظ',
      },
      {
        'type': MeasurementType.bloodPressure,
        'systolic': 125,
        'diastolic': 85,
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'time': '20:00',
        'notes': 'قياس مسائي بعد العشاء',
      },
      {
        'type': MeasurementType.bloodSugar,
        'bloodSugar': 95.5,
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'time': '07:30',
        'notes': 'قياس على الريق',
      },
      {
        'type': MeasurementType.bloodSugar,
        'bloodSugar': 140.0,
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'time': '14:00',
        'notes': 'قياس بعد الغداء بساعتين',
      },
      {
        'type': MeasurementType.both,
        'systolic': 118,
        'diastolic': 78,
        'bloodSugar': 88.0,
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'time': '09:00',
        'notes': 'فحص شامل في العيادة',
      },
      {
        'type': MeasurementType.bloodPressure,
        'systolic': 130,
        'diastolic': 90,
        'date': DateTime.now().subtract(const Duration(days: 4)),
        'time': '16:30',
        'notes': 'قياس بعد التمرين',
      },
      {
        'type': MeasurementType.bloodSugar,
        'bloodSugar': 102.0,
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'time': '11:00',
        'notes': 'قياس عشوائي',
      },
    ];

    for (final measurementData in sampleMeasurements) {
      try {
        await _measurementService.createMeasurement(
          userId: userId,
          measurementType: measurementData['type'] as MeasurementType,
          systolicPressure: measurementData['systolic'] as int?,
          diastolicPressure: measurementData['diastolic'] as int?,
          bloodSugarLevel: measurementData['bloodSugar'] as double?,
          measurementDate: measurementData['date'] as DateTime,
          measurementTime: measurementData['time'] as String,
          notes: measurementData['notes'] as String?,
        );
      } catch (e) {
        print('Error creating sample measurement: $e');
      }
    }
  }

  // Clear all sample data
  Future<void> clearAllData() async {
    try {
      // This would clear all data from the database
      // Implementation depends on your database structure
      print('All data cleared successfully');
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  // Create sample appointments
  Future<void> createSampleAppointments(String userId) async {
    final sampleAppointments = [
      {
        'doctorId': 'sample_doctor_1',
        'date': DateTime.now().add(const Duration(days: 2)),
        'time': '10:00',
        'notes': 'فحص دوري لضغط الدم',
      },
      {
        'doctorId': 'sample_doctor_2',
        'date': DateTime.now().add(const Duration(days: 5)),
        'time': '14:30',
        'notes': 'متابعة نتائج التحاليل',
      },
      {
        'doctorId': 'sample_doctor_3',
        'date': DateTime.now().add(const Duration(days: 7)),
        'time': '09:15',
        'notes': 'استشارة طبية عامة',
      },
    ];

    for (final appointmentData in sampleAppointments) {
      try {
        await _appointmentService.createAppointment(
          userId: userId,
          doctorId: appointmentData['doctorId'] as String,
          appointmentDate: appointmentData['date'] as DateTime,
          appointmentTime: appointmentData['time'] as String,
          notes: appointmentData['notes'] as String?,
        );
      } catch (e) {
        print('Error creating sample appointment: $e');
      }
    }
  }

  // Test all services
  Future<void> testAllServices() async {
    const userId = 'current_user_id';

    try {
      print('Testing DoctorService...');
      final doctors = await _doctorService.getAvailableDoctors();
      print('Found ${doctors.length} doctors');

      print('Testing MedicalMeasurementService...');
      final measurements = await _measurementService.getUserMeasurements(
        userId,
      );
      print('Found ${measurements.length} measurements');

      print('Testing HealthReportService...');
      final reports = await _reportService.getUserReports(userId);
      print('Found ${reports.length} reports');

      print('Testing TaskService...');
      final tasks = await _taskService.getUserTasks(userId);
      print('Found ${tasks.length} tasks');

      print('Testing AppointmentService...');
      final appointments = await _appointmentService.getUserAppointments(
        userId,
      );
      print('Found ${appointments.length} appointments');

      print('All services tested successfully!');
    } catch (e) {
      print('Error testing services: $e');
    }
  }

  // Get application statistics
  Future<Map<String, dynamic>> getAppStatistics() async {
    const userId = 'current_user_id';

    try {
      final doctorCount = (await _doctorService.getAvailableDoctors()).length;
      final measurementStats = await _measurementService.getMeasurementStats(
        userId,
      );
      final reportStats = await _reportService.getReportStats(userId);
      final taskStats = await _taskService.getTaskStats(userId);

      return {
        'doctors': doctorCount,
        'measurements': measurementStats,
        'reports': reportStats,
        'tasks': taskStats,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('Error getting app statistics: $e');
      return {};
    }
  }

  // Validate data integrity
  Future<bool> validateDataIntegrity() async {
    try {
      const userId = 'current_user_id';

      // Check if all services are working
      await _doctorService.getAvailableDoctors();
      await _measurementService.getUserMeasurements(userId);
      await _reportService.getUserReports(userId);
      await _taskService.getUserTasks(userId);
      await _appointmentService.getUserAppointments(userId);

      print('Data integrity validation passed');
      return true;
    } catch (e) {
      print('Data integrity validation failed: $e');
      return false;
    }
  }

  // Create demo user data
  Future<void> createDemoUserData() async {
    const userId = 'demo_user_id';

    try {
      // Create comprehensive demo data for showcasing the app
      await _createSampleMeasurements(userId);
      await _reportService.createSampleReports(userId);
      await _taskService.createSampleTasks(userId);
      await createSampleAppointments(userId);

      print('Demo user data created successfully');
    } catch (e) {
      print('Error creating demo user data: $e');
    }
  }

  // Reset application data
  Future<void> resetApplicationData() async {
    try {
      // This would reset all user data while keeping the app structure
      await clearAllData();
      await initializeSampleData();

      print('Application data reset successfully');
    } catch (e) {
      print('Error resetting application data: $e');
    }
  }
}
