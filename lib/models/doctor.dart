// JSON serialization will be added later
class Doctor {
  final String uuid;
  final String fullName;
  final String specialty;
  final String? email;
  final String phone;
  final String address;
  final String wilaya;
  final String commune;
  final double? consultationFee;
  final double rating;
  final int? yearsExperience;
  final String? profileImage;
  final bool isAvailable;
  final String? workingHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  Doctor({
    required this.uuid,
    required this.fullName,
    required this.specialty,
    this.email,
    required this.phone,
    required this.address,
    required this.wilaya,
    required this.commune,
    this.consultationFee,
    this.rating = 0.0,
    this.yearsExperience,
    this.profileImage,
    this.isAvailable = true,
    this.workingHours,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON serialization methods will be added later

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      uuid: map['uuid'] as String,
      fullName: map['full_name'] as String,
      specialty: map['specialty'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String,
      address: map['address'] as String,
      wilaya: map['wilaya'] as String,
      commune: map['commune'] as String,
      consultationFee: map['consultation_fee'] as double?,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      yearsExperience: map['years_experience'] as int?,
      profileImage: map['profile_image'] as String?,
      isAvailable: (map['is_available'] as int?) == 1,
      workingHours: map['working_hours'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'full_name': fullName,
      'specialty': specialty,
      'email': email,
      'phone': phone,
      'address': address,
      'wilaya': wilaya,
      'commune': commune,
      'consultation_fee': consultationFee,
      'rating': rating,
      'years_experience': yearsExperience,
      'profile_image': profileImage,
      'is_available': isAvailable ? 1 : 0,
      'working_hours': workingHours,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Doctor copyWith({
    String? uuid,
    String? fullName,
    String? specialty,
    String? email,
    String? phone,
    String? address,
    String? wilaya,
    String? commune,
    double? consultationFee,
    double? rating,
    int? yearsExperience,
    String? profileImage,
    bool? isAvailable,
    String? workingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Doctor(
      uuid: uuid ?? this.uuid,
      fullName: fullName ?? this.fullName,
      specialty: specialty ?? this.specialty,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      wilaya: wilaya ?? this.wilaya,
      commune: commune ?? this.commune,
      consultationFee: consultationFee ?? this.consultationFee,
      rating: rating ?? this.rating,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      profileImage: profileImage ?? this.profileImage,
      isAvailable: isAvailable ?? this.isAvailable,
      workingHours: workingHours ?? this.workingHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Doctor && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'Doctor(uuid: $uuid, fullName: $fullName, specialty: $specialty, wilaya: $wilaya)';
  }
}
