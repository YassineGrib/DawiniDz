import '../database/database_helper.dart';
import '../models/medical_measurement.dart';
import 'package:uuid/uuid.dart';

class MedicalMeasurementService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();

  // Create a new medical measurement
  Future<MedicalMeasurement> createMeasurement({
    required String userId,
    required MeasurementType measurementType,
    int? systolicPressure,
    int? diastolicPressure,
    double? bloodSugarLevel,
    required DateTime measurementDate,
    required String measurementTime,
    String? notes,
    String? doctorId,
  }) async {
    final now = DateTime.now();
    final measurement = MedicalMeasurement(
      uuid: _uuid.v4(),
      userId: userId,
      measurementType: measurementType,
      systolicPressure: systolicPressure,
      diastolicPressure: diastolicPressure,
      bloodSugarLevel: bloodSugarLevel,
      measurementDate: measurementDate,
      measurementTime: measurementTime,
      notes: notes,
      sentToDoctor: false,
      doctorId: doctorId,
      createdAt: now,
    );

    await _dbHelper.insert('medical_measurements', measurement.toMap());
    return measurement;
  }

  // Get measurement by UUID
  Future<MedicalMeasurement?> getMeasurementByUuid(String uuid) async {
    final results = await _dbHelper.query(
      'medical_measurements',
      where: 'uuid = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return MedicalMeasurement.fromMap(results.first);
    }
    return null;
  }

  // Get all measurements for a user
  Future<List<MedicalMeasurement>> getUserMeasurements(String userId) async {
    final results = await _dbHelper.query(
      'medical_measurements',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'measurement_date DESC, measurement_time DESC',
    );

    return results.map((map) => MedicalMeasurement.fromMap(map)).toList();
  }

  // Get measurements by type for a user
  Future<List<MedicalMeasurement>> getUserMeasurementsByType(
    String userId,
    MeasurementType type,
  ) async {
    final results = await _dbHelper.query(
      'medical_measurements',
      where: 'user_id = ? AND measurement_type = ?',
      whereArgs: [userId, type.name],
      orderBy: 'measurement_date DESC, measurement_time DESC',
    );

    return results.map((map) => MedicalMeasurement.fromMap(map)).toList();
  }

  // Get measurements for a specific date range
  Future<List<MedicalMeasurement>> getMeasurementsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startDateString = startDate.toIso8601String().split('T')[0];
    final endDateString = endDate.toIso8601String().split('T')[0];

    final results = await _dbHelper.query(
      'medical_measurements',
      where: 'user_id = ? AND measurement_date >= ? AND measurement_date <= ?',
      whereArgs: [userId, startDateString, endDateString],
      orderBy: 'measurement_date ASC, measurement_time ASC',
    );

    return results.map((map) => MedicalMeasurement.fromMap(map)).toList();
  }

  // Get recent measurements (last 30 days)
  Future<List<MedicalMeasurement>> getRecentMeasurements(String userId) async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return await getMeasurementsByDateRange(userId, thirtyDaysAgo, DateTime.now());
  }

  // Get measurements for today
  Future<List<MedicalMeasurement>> getTodayMeasurements(String userId) async {
    final today = DateTime.now();
    final todayString = today.toIso8601String().split('T')[0];

    final results = await _dbHelper.query(
      'medical_measurements',
      where: 'user_id = ? AND measurement_date = ?',
      whereArgs: [userId, todayString],
      orderBy: 'measurement_time DESC',
    );

    return results.map((map) => MedicalMeasurement.fromMap(map)).toList();
  }

  // Update measurement
  Future<bool> updateMeasurement(MedicalMeasurement measurement) async {
    final result = await _dbHelper.update(
      'medical_measurements',
      measurement.toMap(),
      where: 'uuid = ?',
      whereArgs: [measurement.uuid],
    );
    return result > 0;
  }

  // Delete measurement
  Future<bool> deleteMeasurement(String uuid) async {
    final result = await _dbHelper.delete(
      'medical_measurements',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Mark measurement as sent to doctor
  Future<bool> markAsSentToDoctor(String uuid, String doctorId) async {
    final result = await _dbHelper.update(
      'medical_measurements',
      {
        'sent_to_doctor': 1,
        'doctor_id': doctorId,
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Get measurements not sent to doctor
  Future<List<MedicalMeasurement>> getUnsyncedMeasurements(String userId) async {
    final results = await _dbHelper.query(
      'medical_measurements',
      where: 'user_id = ? AND sent_to_doctor = 0',
      whereArgs: [userId],
      orderBy: 'measurement_date DESC, measurement_time DESC',
    );

    return results.map((map) => MedicalMeasurement.fromMap(map)).toList();
  }

  // Get measurement statistics
  Future<Map<String, dynamic>> getMeasurementStats(String userId) async {
    final db = await _dbHelper.database;
    
    // Total measurements
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM medical_measurements WHERE user_id = ?',
      [userId],
    );
    
    // This month measurements
    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1).toIso8601String().split('T')[0];
    final thisMonthResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM medical_measurements WHERE user_id = ? AND measurement_date >= ?',
      [userId, thisMonthStart],
    );
    
    // Blood pressure measurements
    final bpResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM medical_measurements WHERE user_id = ? AND measurement_type IN (?, ?)',
      [userId, 'bloodPressure', 'both'],
    );
    
    // Blood sugar measurements
    final bsResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM medical_measurements WHERE user_id = ? AND measurement_type IN (?, ?)',
      [userId, 'bloodSugar', 'both'],
    );
    
    // Average blood pressure (last 30 days)
    final avgBpResult = await db.rawQuery(
      '''SELECT AVG(systolic_pressure) as avg_systolic, AVG(diastolic_pressure) as avg_diastolic 
         FROM medical_measurements 
         WHERE user_id = ? AND measurement_type IN (?, ?) 
         AND measurement_date >= ?''',
      [userId, 'bloodPressure', 'both', DateTime.now().subtract(const Duration(days: 30)).toIso8601String().split('T')[0]],
    );
    
    // Average blood sugar (last 30 days)
    final avgBsResult = await db.rawQuery(
      '''SELECT AVG(blood_sugar_level) as avg_blood_sugar 
         FROM medical_measurements 
         WHERE user_id = ? AND measurement_type IN (?, ?) 
         AND measurement_date >= ?''',
      [userId, 'bloodSugar', 'both', DateTime.now().subtract(const Duration(days: 30)).toIso8601String().split('T')[0]],
    );

    return {
      'total': totalResult.first['count'] as int,
      'thisMonth': thisMonthResult.first['count'] as int,
      'bloodPressure': bpResult.first['count'] as int,
      'bloodSugar': bsResult.first['count'] as int,
      'avgSystolic': avgBpResult.first['avg_systolic'] as double?,
      'avgDiastolic': avgBpResult.first['avg_diastolic'] as double?,
      'avgBloodSugar': avgBsResult.first['avg_blood_sugar'] as double?,
    };
  }

  // Get blood pressure trend (last 7 days)
  Future<List<Map<String, dynamic>>> getBloodPressureTrend(String userId) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final measurements = await getMeasurementsByDateRange(userId, sevenDaysAgo, DateTime.now());
    
    final bpMeasurements = measurements.where((m) => 
      m.measurementType == MeasurementType.bloodPressure || 
      m.measurementType == MeasurementType.both
    ).toList();

    return bpMeasurements.map((m) => {
      'date': m.measurementDate,
      'systolic': m.systolicPressure,
      'diastolic': m.diastolicPressure,
    }).toList();
  }

  // Get blood sugar trend (last 7 days)
  Future<List<Map<String, dynamic>>> getBloodSugarTrend(String userId) async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final measurements = await getMeasurementsByDateRange(userId, sevenDaysAgo, DateTime.now());
    
    final bsMeasurements = measurements.where((m) => 
      m.measurementType == MeasurementType.bloodSugar || 
      m.measurementType == MeasurementType.both
    ).toList();

    return bsMeasurements.map((m) => {
      'date': m.measurementDate,
      'bloodSugar': m.bloodSugarLevel,
    }).toList();
  }

  // Check if measurement is within normal range
  Map<String, dynamic> analyzeMeasurement(MedicalMeasurement measurement) {
    Map<String, dynamic> analysis = {
      'isNormal': true,
      'warnings': <String>[],
      'recommendations': <String>[],
    };

    // Blood pressure analysis
    if (measurement.systolicPressure != null && measurement.diastolicPressure != null) {
      final systolic = measurement.systolicPressure!;
      final diastolic = measurement.diastolicPressure!;

      if (systolic >= 180 || diastolic >= 110) {
        analysis['isNormal'] = false;
        analysis['warnings'].add('ضغط دم مرتفع جداً - يتطلب عناية طبية فورية');
      } else if (systolic >= 140 || diastolic >= 90) {
        analysis['isNormal'] = false;
        analysis['warnings'].add('ضغط دم مرتفع');
        analysis['recommendations'].add('استشر طبيبك وقلل من الملح في الطعام');
      } else if (systolic < 90 || diastolic < 60) {
        analysis['isNormal'] = false;
        analysis['warnings'].add('ضغط دم منخفض');
        analysis['recommendations'].add('اشرب المزيد من الماء وتجنب الوقوف المفاجئ');
      } else {
        analysis['recommendations'].add('ضغط الدم طبيعي - حافظ على نمط حياة صحي');
      }
    }

    // Blood sugar analysis
    if (measurement.bloodSugarLevel != null) {
      final bloodSugar = measurement.bloodSugarLevel!;

      if (bloodSugar >= 200) {
        analysis['isNormal'] = false;
        analysis['warnings'].add('سكر الدم مرتفع جداً - يتطلب عناية طبية فورية');
      } else if (bloodSugar >= 126) {
        analysis['isNormal'] = false;
        analysis['warnings'].add('سكر الدم مرتفع');
        analysis['recommendations'].add('استشر طبيبك وراقب نظامك الغذائي');
      } else if (bloodSugar < 70) {
        analysis['isNormal'] = false;
        analysis['warnings'].add('سكر الدم منخفض');
        analysis['recommendations'].add('تناول شيئاً حلواً واستشر طبيبك');
      } else {
        analysis['recommendations'].add('سكر الدم طبيعي - حافظ على نظام غذائي متوازن');
      }
    }

    return analysis;
  }
}
