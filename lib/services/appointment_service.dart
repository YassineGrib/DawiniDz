import '../database/database_helper.dart';
import '../models/appointment.dart';
import 'package:uuid/uuid.dart';

class AppointmentService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();

  // Create a new appointment
  Future<Appointment> createAppointment({
    required String userId,
    required String doctorId,
    required DateTime appointmentDate,
    required String appointmentTime,
    String? notes,
  }) async {
    final now = DateTime.now();
    final appointment = Appointment(
      uuid: _uuid.v4(),
      userId: userId,
      doctorId: doctorId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      status: AppointmentStatus.scheduled,
      notes: notes,
      reminderSent: false,
      createdAt: now,
      updatedAt: now,
    );

    await _dbHelper.insert('appointments', appointment.toMap());
    return appointment;
  }

  // Get appointment by UUID
  Future<Appointment?> getAppointmentByUuid(String uuid) async {
    final results = await _dbHelper.query(
      'appointments',
      where: 'uuid = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return Appointment.fromMap(results.first);
    }
    return null;
  }

  // Get appointments for a user
  Future<List<Appointment>> getUserAppointments(String userId) async {
    final results = await _dbHelper.query(
      'appointments',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'appointment_date DESC, appointment_time DESC',
    );

    return results.map((map) => Appointment.fromMap(map)).toList();
  }

  // Get appointments for a doctor
  Future<List<Appointment>> getDoctorAppointments(String doctorId) async {
    final results = await _dbHelper.query(
      'appointments',
      where: 'doctor_id = ?',
      whereArgs: [doctorId],
      orderBy: 'appointment_date ASC, appointment_time ASC',
    );

    return results.map((map) => Appointment.fromMap(map)).toList();
  }

  // Get upcoming appointments for a user
  Future<List<Appointment>> getUpcomingAppointments(String userId) async {
    final today = DateTime.now();
    final todayString = today.toIso8601String().split('T')[0];

    final results = await _dbHelper.query(
      'appointments',
      where: 'user_id = ? AND appointment_date >= ? AND status IN (?, ?)',
      whereArgs: [userId, todayString, 'scheduled', 'confirmed'],
      orderBy: 'appointment_date ASC, appointment_time ASC',
    );

    return results.map((map) => Appointment.fromMap(map)).toList();
  }

  // Get past appointments for a user
  Future<List<Appointment>> getPastAppointments(String userId) async {
    final today = DateTime.now();
    final todayString = today.toIso8601String().split('T')[0];

    final results = await _dbHelper.query(
      'appointments',
      where: 'user_id = ? AND (appointment_date < ? OR status IN (?, ?))',
      whereArgs: [userId, todayString, 'completed', 'cancelled'],
      orderBy: 'appointment_date DESC, appointment_time DESC',
    );

    return results.map((map) => Appointment.fromMap(map)).toList();
  }

  // Update appointment status
  Future<bool> updateAppointmentStatus(String uuid, AppointmentStatus status) async {
    final result = await _dbHelper.update(
      'appointments',
      {
        'status': status.name,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Update appointment
  Future<bool> updateAppointment(Appointment appointment) async {
    final updatedAppointment = appointment.copyWith(updatedAt: DateTime.now());
    final result = await _dbHelper.update(
      'appointments',
      updatedAppointment.toMap(),
      where: 'uuid = ?',
      whereArgs: [appointment.uuid],
    );
    return result > 0;
  }

  // Cancel appointment
  Future<bool> cancelAppointment(String uuid) async {
    return await updateAppointmentStatus(uuid, AppointmentStatus.cancelled);
  }

  // Confirm appointment
  Future<bool> confirmAppointment(String uuid) async {
    return await updateAppointmentStatus(uuid, AppointmentStatus.confirmed);
  }

  // Complete appointment
  Future<bool> completeAppointment(String uuid) async {
    return await updateAppointmentStatus(uuid, AppointmentStatus.completed);
  }

  // Reschedule appointment
  Future<bool> rescheduleAppointment(
    String uuid,
    DateTime newDate,
    String newTime,
  ) async {
    final result = await _dbHelper.update(
      'appointments',
      {
        'appointment_date': newDate.toIso8601String().split('T')[0],
        'appointment_time': newTime,
        'status': AppointmentStatus.rescheduled.name,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Check if time slot is available
  Future<bool> isTimeSlotAvailable(
    String doctorId,
    DateTime date,
    String time,
  ) async {
    final dateString = date.toIso8601String().split('T')[0];
    final results = await _dbHelper.query(
      'appointments',
      where: 'doctor_id = ? AND appointment_date = ? AND appointment_time = ? AND status NOT IN (?, ?)',
      whereArgs: [doctorId, dateString, time, 'cancelled', 'completed'],
      limit: 1,
    );

    return results.isEmpty;
  }

  // Get appointments for a specific date
  Future<List<Appointment>> getAppointmentsByDate(String userId, DateTime date) async {
    final dateString = date.toIso8601String().split('T')[0];
    final results = await _dbHelper.query(
      'appointments',
      where: 'user_id = ? AND appointment_date = ?',
      whereArgs: [userId, dateString],
      orderBy: 'appointment_time ASC',
    );

    return results.map((map) => Appointment.fromMap(map)).toList();
  }

  // Get appointments that need reminders
  Future<List<Appointment>> getAppointmentsNeedingReminders() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowString = tomorrow.toIso8601String().split('T')[0];

    final results = await _dbHelper.query(
      'appointments',
      where: 'appointment_date = ? AND reminder_sent = 0 AND status IN (?, ?)',
      whereArgs: [tomorrowString, 'scheduled', 'confirmed'],
      orderBy: 'appointment_time ASC',
    );

    return results.map((map) => Appointment.fromMap(map)).toList();
  }

  // Mark reminder as sent
  Future<bool> markReminderSent(String uuid) async {
    final result = await _dbHelper.update(
      'appointments',
      {
        'reminder_sent': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Delete appointment
  Future<bool> deleteAppointment(String uuid) async {
    final result = await _dbHelper.delete(
      'appointments',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Get appointment statistics for a user
  Future<Map<String, int>> getAppointmentStats(String userId) async {
    final db = await _dbHelper.database;
    
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM appointments WHERE user_id = ?',
      [userId],
    );
    
    final completedResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM appointments WHERE user_id = ? AND status = ?',
      [userId, 'completed'],
    );
    
    final upcomingResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM appointments WHERE user_id = ? AND status IN (?, ?) AND appointment_date >= ?',
      [userId, 'scheduled', 'confirmed', DateTime.now().toIso8601String().split('T')[0]],
    );
    
    final cancelledResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM appointments WHERE user_id = ? AND status = ?',
      [userId, 'cancelled'],
    );

    return {
      'total': totalResult.first['count'] as int,
      'completed': completedResult.first['count'] as int,
      'upcoming': upcomingResult.first['count'] as int,
      'cancelled': cancelledResult.first['count'] as int,
    };
  }
}
