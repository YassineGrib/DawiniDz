// JSON serialization will be added later
class HealthReport {
  final String uuid;
  final String userId;
  final String doctorId;
  final String? measurementId;
  final String reportTitle;
  final String interpretation;
  final String? medicalNotes;
  final String? nutritionAdvice;
  final String? activityAdvice;
  final String? treatmentModifications;
  final DateTime? nextCheckupDate;
  final DateTime createdAt;

  HealthReport({
    required this.uuid,
    required this.userId,
    required this.doctorId,
    this.measurementId,
    required this.reportTitle,
    required this.interpretation,
    this.medicalNotes,
    this.nutritionAdvice,
    this.activityAdvice,
    this.treatmentModifications,
    this.nextCheckupDate,
    required this.createdAt,
  });

  // JSON serialization methods will be added later

  factory HealthReport.fromMap(Map<String, dynamic> map) {
    return HealthReport(
      uuid: map['uuid'] as String,
      userId: map['user_id'] as String,
      doctorId: map['doctor_id'] as String,
      measurementId: map['measurement_id'] as String?,
      reportTitle: map['report_title'] as String,
      interpretation: map['interpretation'] as String,
      medicalNotes: map['medical_notes'] as String?,
      nutritionAdvice: map['nutrition_advice'] as String?,
      activityAdvice: map['activity_advice'] as String?,
      treatmentModifications: map['treatment_modifications'] as String?,
      nextCheckupDate: map['next_checkup_date'] != null
          ? DateTime.parse(map['next_checkup_date'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'doctor_id': doctorId,
      'measurement_id': measurementId,
      'report_title': reportTitle,
      'interpretation': interpretation,
      'medical_notes': medicalNotes,
      'nutrition_advice': nutritionAdvice,
      'activity_advice': activityAdvice,
      'treatment_modifications': treatmentModifications,
      'next_checkup_date': nextCheckupDate?.toIso8601String().split('T')[0],
      'created_at': createdAt.toIso8601String(),
    };
  }

  HealthReport copyWith({
    String? uuid,
    String? userId,
    String? doctorId,
    String? measurementId,
    String? reportTitle,
    String? interpretation,
    String? medicalNotes,
    String? nutritionAdvice,
    String? activityAdvice,
    String? treatmentModifications,
    DateTime? nextCheckupDate,
    DateTime? createdAt,
  }) {
    return HealthReport(
      uuid: uuid ?? this.uuid,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      measurementId: measurementId ?? this.measurementId,
      reportTitle: reportTitle ?? this.reportTitle,
      interpretation: interpretation ?? this.interpretation,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      nutritionAdvice: nutritionAdvice ?? this.nutritionAdvice,
      activityAdvice: activityAdvice ?? this.activityAdvice,
      treatmentModifications:
          treatmentModifications ?? this.treatmentModifications,
      nextCheckupDate: nextCheckupDate ?? this.nextCheckupDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthReport && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'HealthReport(uuid: $uuid, title: $reportTitle, doctorId: $doctorId)';
  }
}
