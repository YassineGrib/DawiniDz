// JSON serialization will be added later

enum MeasurementType { bloodPressure, bloodSugar, both }

class MedicalMeasurement {
  final String uuid;
  final String userId;
  final MeasurementType measurementType;
  final int? systolicPressure;
  final int? diastolicPressure;
  final double? bloodSugarLevel;
  final DateTime measurementDate;
  final String measurementTime;
  final String? notes;
  final bool sentToDoctor;
  final String? doctorId;
  final DateTime createdAt;

  MedicalMeasurement({
    required this.uuid,
    required this.userId,
    required this.measurementType,
    this.systolicPressure,
    this.diastolicPressure,
    this.bloodSugarLevel,
    required this.measurementDate,
    required this.measurementTime,
    this.notes,
    this.sentToDoctor = false,
    this.doctorId,
    required this.createdAt,
  });

  // JSON serialization methods will be added later

  factory MedicalMeasurement.fromMap(Map<String, dynamic> map) {
    return MedicalMeasurement(
      uuid: map['uuid'] as String,
      userId: map['user_id'] as String,
      measurementType: MeasurementType.values.firstWhere(
        (e) => e.name == map['measurement_type'],
        orElse: () => MeasurementType.bloodPressure,
      ),
      systolicPressure: map['systolic_pressure'] as int?,
      diastolicPressure: map['diastolic_pressure'] as int?,
      bloodSugarLevel: (map['blood_sugar_level'] as num?)?.toDouble(),
      measurementDate: DateTime.parse(map['measurement_date'] as String),
      measurementTime: map['measurement_time'] as String,
      notes: map['notes'] as String?,
      sentToDoctor: (map['sent_to_doctor'] as int?) == 1,
      doctorId: map['doctor_id'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'measurement_type': measurementType.name,
      'systolic_pressure': systolicPressure,
      'diastolic_pressure': diastolicPressure,
      'blood_sugar_level': bloodSugarLevel,
      'measurement_date': measurementDate.toIso8601String().split('T')[0],
      'measurement_time': measurementTime,
      'notes': notes,
      'sent_to_doctor': sentToDoctor ? 1 : 0,
      'doctor_id': doctorId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get bloodPressureReading {
    if (systolicPressure != null && diastolicPressure != null) {
      return '$systolicPressure/$diastolicPressure mmHg';
    }
    return 'N/A';
  }

  String get bloodSugarReading {
    if (bloodSugarLevel != null) {
      return '${bloodSugarLevel!.toStringAsFixed(1)} mg/dL';
    }
    return 'N/A';
  }

  String get displayValue {
    switch (measurementType) {
      case MeasurementType.bloodPressure:
        return bloodPressureReading;
      case MeasurementType.bloodSugar:
        return bloodSugarReading;
      case MeasurementType.both:
        return '$bloodPressureReading, $bloodSugarReading';
    }
  }

  MedicalMeasurement copyWith({
    String? uuid,
    String? userId,
    MeasurementType? measurementType,
    int? systolicPressure,
    int? diastolicPressure,
    double? bloodSugarLevel,
    DateTime? measurementDate,
    String? measurementTime,
    String? notes,
    bool? sentToDoctor,
    String? doctorId,
    DateTime? createdAt,
  }) {
    return MedicalMeasurement(
      uuid: uuid ?? this.uuid,
      userId: userId ?? this.userId,
      measurementType: measurementType ?? this.measurementType,
      systolicPressure: systolicPressure ?? this.systolicPressure,
      diastolicPressure: diastolicPressure ?? this.diastolicPressure,
      bloodSugarLevel: bloodSugarLevel ?? this.bloodSugarLevel,
      measurementDate: measurementDate ?? this.measurementDate,
      measurementTime: measurementTime ?? this.measurementTime,
      notes: notes ?? this.notes,
      sentToDoctor: sentToDoctor ?? this.sentToDoctor,
      doctorId: doctorId ?? this.doctorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedicalMeasurement && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'MedicalMeasurement(uuid: $uuid, type: $measurementType, date: $measurementDate)';
  }
}
