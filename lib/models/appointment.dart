// JSON serialization will be added later

enum AppointmentStatus {
  scheduled,
  confirmed,
  completed,
  cancelled,
  rescheduled,
}

class Appointment {
  final String uuid;
  final String userId;
  final String doctorId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final AppointmentStatus status;
  final String? notes;
  final bool reminderSent;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.uuid,
    required this.userId,
    required this.doctorId,
    required this.appointmentDate,
    required this.appointmentTime,
    this.status = AppointmentStatus.scheduled,
    this.notes,
    this.reminderSent = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON serialization methods will be added later

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      uuid: map['uuid'] as String,
      userId: map['user_id'] as String,
      doctorId: map['doctor_id'] as String,
      appointmentDate: DateTime.parse(map['appointment_date'] as String),
      appointmentTime: map['appointment_time'] as String,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
      notes: map['notes'] as String?,
      reminderSent: (map['reminder_sent'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'doctor_id': doctorId,
      'appointment_date': appointmentDate.toIso8601String().split('T')[0],
      'appointment_time': appointmentTime,
      'status': status.name,
      'notes': notes,
      'reminder_sent': reminderSent ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Appointment copyWith({
    String? uuid,
    String? userId,
    String? doctorId,
    DateTime? appointmentDate,
    String? appointmentTime,
    AppointmentStatus? status,
    String? notes,
    bool? reminderSent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      uuid: uuid ?? this.uuid,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      reminderSent: reminderSent ?? this.reminderSent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Appointment && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'Appointment(uuid: $uuid, doctorId: $doctorId, date: $appointmentDate, status: $status)';
  }
}
