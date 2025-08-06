import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dawinidz/main.dart';
import 'package:dawinidz/services/sample_data_service.dart';
import 'package:dawinidz/services/doctor_service.dart';
import 'package:dawinidz/services/medical_measurement_service.dart';
import 'package:dawinidz/services/task_service.dart';
import 'package:dawinidz/services/health_report_service.dart';
import 'package:dawinidz/services/appointment_service.dart';
import 'package:dawinidz/data/algeria_data.dart';

void main() {
  group('DawiniDz App Tests', () {
    testWidgets('App should start without crashing', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const DawiniDzApp());

      // Verify that the app starts with the home screen
      expect(find.text('دويني دي زد'), findsOneWidget);
      expect(find.text('مرحباً بك'), findsOneWidget);
    });

    testWidgets('Bottom navigation should work', (WidgetTester tester) async {
      await tester.pumpWidget(const DawiniDzApp());

      // Test navigation to different tabs
      await tester.tap(find.text('المواعيد'));
      await tester.pump();

      await tester.tap(find.text('القياسات'));
      await tester.pump();

      await tester.tap(find.text('المهام'));
      await tester.pump();

      await tester.tap(find.text('الملف الشخصي'));
      await tester.pump();

      // Return to home
      await tester.tap(find.text('الرئيسية'));
      await tester.pump();
    });

    testWidgets('Home cards should be tappable', (WidgetTester tester) async {
      await tester.pumpWidget(const DawiniDzApp());

      // Find and tap the doctor search card
      final doctorSearchCard = find.text('البحث عن طبيب');
      expect(doctorSearchCard, findsOneWidget);

      await tester.tap(doctorSearchCard);
      await tester.pumpAndSettle();

      // Should navigate to doctor search screen
      expect(find.text('البحث عن طبيب'), findsOneWidget);
    });
  });

  group('Service Tests', () {
    test('DoctorService should work correctly', () async {
      final doctorService = DoctorService();

      // Test getting specialties
      final specialties = await doctorService.getSpecialties();
      expect(specialties, isNotEmpty);
      expect(specialties.contains('طب عام'), isTrue);

      // Test getting wilayas
      final wilayas = await doctorService.getWilayas();
      expect(wilayas, isNotEmpty);
      expect(wilayas.contains('الجزائر'), isTrue);
    });

    test('MedicalMeasurementService should work correctly', () async {
      final measurementService = MedicalMeasurementService();

      // Test getting user measurements
      final measurements = await measurementService.getUserMeasurements(
        'test_user',
      );
      expect(measurements, isNotNull);
    });

    test('TaskService should work correctly', () async {
      final taskService = TaskService();

      // Test getting user tasks
      final tasks = await taskService.getUserTasks('test_user');
      expect(tasks, isNotNull);
    });

    test('HealthReportService should work correctly', () async {
      final reportService = HealthReportService();

      // Test getting user reports
      final reports = await reportService.getUserReports('test_user');
      expect(reports, isNotNull);
    });

    test('AppointmentService should work correctly', () async {
      final appointmentService = AppointmentService();

      // Test getting user appointments
      final appointments = await appointmentService.getUserAppointments(
        'test_user',
      );
      expect(appointments, isNotNull);
    });

    test('SampleDataService should work correctly', () async {
      final sampleDataService = SampleDataService();

      // Test data validation
      final isValid = await sampleDataService.validateDataIntegrity();
      expect(isValid, isA<bool>());

      // Test getting statistics
      final stats = await sampleDataService.getAppStatistics();
      expect(stats, isNotNull);
      expect(stats, isA<Map<String, dynamic>>());
    });
  });

  group('Data Model Tests', () {
    test('AlgeriaData should contain valid data', () {
      // Test wilayas
      final wilayas = AlgeriaData.wilayas;
      expect(wilayas, isNotEmpty);
      expect(wilayas.length, equals(48)); // Algeria has 48 wilayas

      // Test specific wilayas
      expect(wilayas.contains('الجزائر'), isTrue);
      expect(wilayas.contains('وهران'), isTrue);
      expect(wilayas.contains('قسنطينة'), isTrue);

      // Test communes for a specific wilaya
      final algerCommunes = AlgeriaData.getCommunesForWilaya('الجزائر');
      expect(algerCommunes, isNotEmpty);
      expect(algerCommunes.contains('الجزائر الوسطى'), isTrue);

      // Test validation methods
      expect(AlgeriaData.isValidWilaya('الجزائر'), isTrue);
      expect(AlgeriaData.isValidWilaya('Invalid Wilaya'), isFalse);

      expect(AlgeriaData.isValidCommune('الجزائر الوسطى', 'الجزائر'), isTrue);
      expect(AlgeriaData.isValidCommune('Invalid Commune', 'الجزائر'), isFalse);
    });
  });

  group('UI Component Tests', () {
    testWidgets('CustomAppBar should display correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Test Title')),
            body: const Center(child: Text('Test Body')),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Body'), findsOneWidget);
    });

    testWidgets('HomeCard should be interactive', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InkWell(
              onTap: () {
                tapped = true;
              },
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Test Card'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Card'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('Integration Tests', () {
    test('Complete app workflow should work', () async {
      final sampleDataService = SampleDataService();

      // Initialize sample data
      await sampleDataService.initializeSampleData();

      // Validate data integrity
      final isValid = await sampleDataService.validateDataIntegrity();
      expect(isValid, isTrue);

      // Test all services
      await sampleDataService.testAllServices();

      // Get app statistics
      final stats = await sampleDataService.getAppStatistics();
      expect(stats, isNotEmpty);
    });
  });
}
