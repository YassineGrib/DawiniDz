import '../database/database_helper.dart';
import '../models/health_report.dart';
import 'package:uuid/uuid.dart';

class HealthReportService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();

  // Create a new health report
  Future<HealthReport> createReport({
    required String userId,
    required String doctorId,
    String? measurementId,
    required String reportTitle,
    required String interpretation,
    String? medicalNotes,
    String? nutritionAdvice,
    String? activityAdvice,
    String? treatmentModifications,
    DateTime? nextCheckupDate,
  }) async {
    final now = DateTime.now();
    final report = HealthReport(
      uuid: _uuid.v4(),
      userId: userId,
      doctorId: doctorId,
      measurementId: measurementId,
      reportTitle: reportTitle,
      interpretation: interpretation,
      medicalNotes: medicalNotes,
      nutritionAdvice: nutritionAdvice,
      activityAdvice: activityAdvice,
      treatmentModifications: treatmentModifications,
      nextCheckupDate: nextCheckupDate,
      createdAt: now,
    );

    await _dbHelper.insert('health_reports', report.toMap());
    return report;
  }

  // Get report by UUID
  Future<HealthReport?> getReportByUuid(String uuid) async {
    final results = await _dbHelper.query(
      'health_reports',
      where: 'uuid = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return HealthReport.fromMap(results.first);
    }
    return null;
  }

  // Get all reports for a user
  Future<List<HealthReport>> getUserReports(String userId) async {
    final results = await _dbHelper.query(
      'health_reports',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => HealthReport.fromMap(map)).toList();
  }

  // Get reports by doctor
  Future<List<HealthReport>> getDoctorReports(String doctorId) async {
    final results = await _dbHelper.query(
      'health_reports',
      where: 'doctor_id = ?',
      whereArgs: [doctorId],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => HealthReport.fromMap(map)).toList();
  }

  // Get reports for a specific measurement
  Future<List<HealthReport>> getReportsForMeasurement(String measurementId) async {
    final results = await _dbHelper.query(
      'health_reports',
      where: 'measurement_id = ?',
      whereArgs: [measurementId],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => HealthReport.fromMap(map)).toList();
  }

  // Get recent reports (last 30 days)
  Future<List<HealthReport>> getRecentReports(String userId) async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final thirtyDaysAgoString = thirtyDaysAgo.toIso8601String();

    final results = await _dbHelper.query(
      'health_reports',
      where: 'user_id = ? AND created_at >= ?',
      whereArgs: [userId, thirtyDaysAgoString],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => HealthReport.fromMap(map)).toList();
  }

  // Get reports with upcoming checkups
  Future<List<HealthReport>> getReportsWithUpcomingCheckups(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];

    final results = await _dbHelper.query(
      'health_reports',
      where: 'user_id = ? AND next_checkup_date >= ?',
      whereArgs: [userId, today],
      orderBy: 'next_checkup_date ASC',
    );

    return results.map((map) => HealthReport.fromMap(map)).toList();
  }

  // Update report
  Future<bool> updateReport(HealthReport report) async {
    final result = await _dbHelper.update(
      'health_reports',
      report.toMap(),
      where: 'uuid = ?',
      whereArgs: [report.uuid],
    );
    return result > 0;
  }

  // Delete report
  Future<bool> deleteReport(String uuid) async {
    final result = await _dbHelper.delete(
      'health_reports',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Search reports by title or content
  Future<List<HealthReport>> searchReports(String userId, String query) async {
    final results = await _dbHelper.query(
      'health_reports',
      where: 'user_id = ? AND (report_title LIKE ? OR interpretation LIKE ? OR medical_notes LIKE ?)',
      whereArgs: [userId, '%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => HealthReport.fromMap(map)).toList();
  }

  // Get report statistics for a user
  Future<Map<String, dynamic>> getReportStats(String userId) async {
    final db = await _dbHelper.database;
    
    // Total reports
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM health_reports WHERE user_id = ?',
      [userId],
    );
    
    // This month reports
    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1).toIso8601String();
    final thisMonthResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM health_reports WHERE user_id = ? AND created_at >= ?',
      [userId, thisMonthStart],
    );
    
    // Reports with upcoming checkups
    final today = DateTime.now().toIso8601String().split('T')[0];
    final upcomingCheckupsResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM health_reports WHERE user_id = ? AND next_checkup_date >= ?',
      [userId, today],
    );
    
    // Reports by different doctors
    final doctorsResult = await db.rawQuery(
      'SELECT COUNT(DISTINCT doctor_id) as count FROM health_reports WHERE user_id = ?',
      [userId],
    );

    return {
      'total': totalResult.first['count'] as int,
      'thisMonth': thisMonthResult.first['count'] as int,
      'upcomingCheckups': upcomingCheckupsResult.first['count'] as int,
      'differentDoctors': doctorsResult.first['count'] as int,
    };
  }

  // Get reports grouped by doctor
  Future<Map<String, List<HealthReport>>> getReportsGroupedByDoctor(String userId) async {
    final reports = await getUserReports(userId);
    final Map<String, List<HealthReport>> groupedReports = {};

    for (final report in reports) {
      if (!groupedReports.containsKey(report.doctorId)) {
        groupedReports[report.doctorId] = [];
      }
      groupedReports[report.doctorId]!.add(report);
    }

    return groupedReports;
  }

  // Get reports for a specific date range
  Future<List<HealthReport>> getReportsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startDateString = startDate.toIso8601String();
    final endDateString = endDate.toIso8601String();

    final results = await _dbHelper.query(
      'health_reports',
      where: 'user_id = ? AND created_at >= ? AND created_at <= ?',
      whereArgs: [userId, startDateString, endDateString],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => HealthReport.fromMap(map)).toList();
  }

  // Create sample reports for testing
  Future<void> createSampleReports(String userId) async {
    final sampleReports = [
      {
        'reportTitle': 'تقرير ضغط الدم الشهري',
        'interpretation': 'قراءات ضغط الدم ضمن المعدل الطبيعي خلال الشهر الماضي. يُنصح بالاستمرار في النظام الغذائي الحالي والتمارين الرياضية.',
        'medicalNotes': 'المريض يتبع العلاج بانتظام ولا توجد أعراض جانبية.',
        'nutritionAdvice': 'تقليل الملح في الطعام والإكثار من الخضروات والفواكه.',
        'activityAdvice': 'المشي لمدة 30 دقيقة يومياً والسباحة مرتين في الأسبوع.',
        'nextCheckupDate': DateTime.now().add(const Duration(days: 30)),
      },
      {
        'reportTitle': 'تحليل سكر الدم',
        'interpretation': 'مستويات السكر في الدم مستقرة ولكن تحتاج إلى مراقبة أكثر دقة.',
        'medicalNotes': 'يُنصح بفحص السكر يومياً في نفس الوقت.',
        'nutritionAdvice': 'تجنب السكريات البسيطة والإكثار من الألياف.',
        'activityAdvice': 'ممارسة الرياضة بعد الوجبات بساعة واحدة.',
        'nextCheckupDate': DateTime.now().add(const Duration(days: 14)),
      },
      {
        'reportTitle': 'فحص دوري شامل',
        'interpretation': 'الحالة الصحية العامة جيدة مع بعض التوصيات للتحسين.',
        'medicalNotes': 'جميع الفحوصات ضمن المعدل الطبيعي.',
        'nutritionAdvice': 'نظام غذائي متوازن مع تقليل الدهون المشبعة.',
        'activityAdvice': 'زيادة النشاط البدني تدريجياً.',
        'nextCheckupDate': DateTime.now().add(const Duration(days: 90)),
      },
    ];

    for (final reportData in sampleReports) {
      try {
        await createReport(
          userId: userId,
          doctorId: 'sample_doctor_id',
          reportTitle: reportData['reportTitle'] as String,
          interpretation: reportData['interpretation'] as String,
          medicalNotes: reportData['medicalNotes'] as String?,
          nutritionAdvice: reportData['nutritionAdvice'] as String?,
          activityAdvice: reportData['activityAdvice'] as String?,
          nextCheckupDate: reportData['nextCheckupDate'] as DateTime?,
        );
      } catch (e) {
        print('Error creating sample report: $e');
      }
    }
  }
}
