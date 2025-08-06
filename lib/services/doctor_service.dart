import '../database/database_helper.dart';
import '../models/doctor.dart';
import '../data/algeria_data.dart';
import 'package:uuid/uuid.dart';

class DoctorService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();

  // Create a new doctor
  Future<Doctor> createDoctor({
    required String fullName,
    required String specialty,
    String? email,
    required String phone,
    required String address,
    required String wilaya,
    required String commune,
    double? consultationFee,
    double rating = 0.0,
    int? yearsExperience,
    String? profileImage,
    bool isAvailable = true,
    String? workingHours,
  }) async {
    final now = DateTime.now();
    final doctor = Doctor(
      uuid: _uuid.v4(),
      fullName: fullName,
      specialty: specialty,
      email: email,
      phone: phone,
      address: address,
      wilaya: wilaya,
      commune: commune,
      consultationFee: consultationFee,
      rating: rating,
      yearsExperience: yearsExperience,
      profileImage: profileImage,
      isAvailable: isAvailable,
      workingHours: workingHours,
      createdAt: now,
      updatedAt: now,
    );

    await _dbHelper.insert('doctors', doctor.toMap());
    return doctor;
  }

  // Get doctor by UUID
  Future<Doctor?> getDoctorByUuid(String uuid) async {
    final results = await _dbHelper.query(
      'doctors',
      where: 'uuid = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return Doctor.fromMap(results.first);
    }
    return null;
  }

  // Search doctors by name
  Future<List<Doctor>> searchDoctorsByName(String name) async {
    final results = await _dbHelper.query(
      'doctors',
      where: 'full_name LIKE ? AND is_available = 1',
      whereArgs: ['%$name%'],
      orderBy: 'rating DESC, full_name ASC',
    );

    return results.map((map) => Doctor.fromMap(map)).toList();
  }

  // Search doctors by specialty
  Future<List<Doctor>> searchDoctorsBySpecialty(String specialty) async {
    final results = await _dbHelper.query(
      'doctors',
      where: 'specialty LIKE ? AND is_available = 1',
      whereArgs: ['%$specialty%'],
      orderBy: 'rating DESC, full_name ASC',
    );

    return results.map((map) => Doctor.fromMap(map)).toList();
  }

  // Search doctors by location (wilaya)
  Future<List<Doctor>> searchDoctorsByLocation(
    String wilaya, {
    String? commune,
  }) async {
    String whereClause = 'wilaya LIKE ? AND is_available = 1';
    List<dynamic> whereArgs = ['%$wilaya%'];

    if (commune != null && commune.isNotEmpty) {
      whereClause += ' AND commune LIKE ?';
      whereArgs.add('%$commune%');
    }

    final results = await _dbHelper.query(
      'doctors',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'rating DESC, full_name ASC',
    );

    return results.map((map) => Doctor.fromMap(map)).toList();
  }

  // Get all available doctors
  Future<List<Doctor>> getAvailableDoctors() async {
    final results = await _dbHelper.query(
      'doctors',
      where: 'is_available = 1',
      orderBy: 'rating DESC, full_name ASC',
    );

    return results.map((map) => Doctor.fromMap(map)).toList();
  }

  // Get doctors by specialty and location
  Future<List<Doctor>> searchDoctors({
    String? name,
    String? specialty,
    String? wilaya,
    String? commune,
  }) async {
    List<String> conditions = ['is_available = 1'];
    List<dynamic> args = [];

    if (name != null && name.isNotEmpty) {
      conditions.add('full_name LIKE ?');
      args.add('%$name%');
    }

    if (specialty != null && specialty.isNotEmpty) {
      conditions.add('specialty LIKE ?');
      args.add('%$specialty%');
    }

    if (wilaya != null && wilaya.isNotEmpty) {
      conditions.add('wilaya LIKE ?');
      args.add('%$wilaya%');
    }

    if (commune != null && commune.isNotEmpty) {
      conditions.add('commune LIKE ?');
      args.add('%$commune%');
    }

    final results = await _dbHelper.query(
      'doctors',
      where: conditions.join(' AND '),
      whereArgs: args,
      orderBy: 'rating DESC, full_name ASC',
    );

    return results.map((map) => Doctor.fromMap(map)).toList();
  }

  // Update doctor
  Future<bool> updateDoctor(Doctor doctor) async {
    final updatedDoctor = doctor.copyWith(updatedAt: DateTime.now());
    final result = await _dbHelper.update(
      'doctors',
      updatedDoctor.toMap(),
      where: 'uuid = ?',
      whereArgs: [doctor.uuid],
    );
    return result > 0;
  }

  // Update doctor availability
  Future<bool> updateDoctorAvailability(String uuid, bool isAvailable) async {
    final result = await _dbHelper.update(
      'doctors',
      {
        'is_available': isAvailable ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Update doctor rating
  Future<bool> updateDoctorRating(String uuid, double rating) async {
    final result = await _dbHelper.update(
      'doctors',
      {'rating': rating, 'updated_at': DateTime.now().toIso8601String()},
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Get unique specialties
  Future<List<String>> getSpecialties() async {
    // Return common medical specialties in Arabic
    return [
      'طب عام',
      'طب الأطفال',
      'طب النساء والتوليد',
      'طب القلب',
      'طب الأعصاب',
      'طب العيون',
      'طب الأسنان',
      'طب الجلدية',
      'طب العظام',
      'طب الأنف والأذن والحنجرة',
      'طب الباطنة',
      'الجراحة العامة',
      'طب النفسية',
      'طب الأشعة',
      'طب التخدير',
    ];
  }

  // Get all wilayas from Algeria data
  Future<List<String>> getWilayas() async {
    return AlgeriaData.wilayas;
  }

  // Get communes for a specific wilaya
  Future<List<String>> getCommunesForWilaya(String wilaya) async {
    return AlgeriaData.getCommunesForWilaya(wilaya);
  }

  // Delete doctor
  Future<bool> deleteDoctor(String uuid) async {
    final result = await _dbHelper.delete(
      'doctors',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }
}
