// JSON serialization will be added later

enum TaskCategory { general, medical, appointment, medication, exercise, diet }

extension TaskCategoryExtension on TaskCategory {
  bool get isNotEmpty => true; // Enums are never empty
  bool get isEmpty => false; // Enums are never empty

  String get displayName {
    switch (this) {
      case TaskCategory.general:
        return 'عام';
      case TaskCategory.medical:
        return 'طبي';
      case TaskCategory.appointment:
        return 'موعد';
      case TaskCategory.medication:
        return 'دواء';
      case TaskCategory.exercise:
        return 'تمرين';
      case TaskCategory.diet:
        return 'غذاء';
    }
  }
}

enum TaskPriority { low, medium, high, urgent }

enum TaskStatus { pending, inProgress, completed, cancelled, overdue }

class Task {
  final String uuid;
  final String userId;
  final String title;
  final String? description;
  final TaskCategory category;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final bool isMedicalRelated;
  final String? relatedAppointmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.uuid,
    required this.userId,
    required this.title,
    this.description,
    this.category = TaskCategory.general,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.dueDate,
    this.reminderDate,
    this.isMedicalRelated = false,
    this.relatedAppointmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON serialization methods will be added later

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      uuid: map['uuid'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: TaskCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => TaskCategory.general,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TaskStatus.pending,
      ),
      dueDate: map['due_date'] != null
          ? DateTime.parse(map['due_date'] as String)
          : null,
      reminderDate: map['reminder_date'] != null
          ? DateTime.parse(map['reminder_date'] as String)
          : null,
      isMedicalRelated: (map['is_medical_related'] as int?) == 1,
      relatedAppointmentId: map['related_appointment_id'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category.name,
      'priority': priority.name,
      'status': status.name,
      'due_date': dueDate?.toIso8601String(),
      'reminder_date': reminderDate?.toIso8601String(),
      'is_medical_related': isMedicalRelated ? 1 : 0,
      'related_appointment_id': relatedAppointmentId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  bool get isDueSoon {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final difference = dueDate!.difference(now).inDays;
    return difference >= 0 && difference <= 3;
  }

  // Convenience getters for compatibility
  bool get isCompleted => status == TaskStatus.completed;

  DateTime? get completedAt {
    // This would need to be stored separately in the database
    // For now, return null or implement based on your needs
    return status == TaskStatus.completed ? updatedAt : null;
  }

  DateTime? get reminderTime => reminderDate;

  Task copyWith({
    String? uuid,
    String? userId,
    String? title,
    String? description,
    TaskCategory? category,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    DateTime? reminderDate,
    bool? isMedicalRelated,
    String? relatedAppointmentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      uuid: uuid ?? this.uuid,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      isMedicalRelated: isMedicalRelated ?? this.isMedicalRelated,
      relatedAppointmentId: relatedAppointmentId ?? this.relatedAppointmentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'Task(uuid: $uuid, title: $title, status: $status, priority: $priority)';
  }
}
