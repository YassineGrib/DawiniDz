import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../models/task.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Mock notification settings
  bool _notificationsEnabled = true;
  bool _appointmentReminders = true;
  bool _medicationReminders = true;
  bool _healthTips = false;

  // Getters for settings
  bool get notificationsEnabled => _notificationsEnabled;
  bool get appointmentReminders => _appointmentReminders;
  bool get medicationReminders => _medicationReminders;
  bool get healthTips => _healthTips;

  // Setters for settings
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    if (!enabled) {
      _appointmentReminders = false;
      _medicationReminders = false;
      _healthTips = false;
    }
  }

  void setAppointmentReminders(bool enabled) {
    _appointmentReminders = enabled && _notificationsEnabled;
  }

  void setMedicationReminders(bool enabled) {
    _medicationReminders = enabled && _notificationsEnabled;
  }

  void setHealthTips(bool enabled) {
    _healthTips = enabled && _notificationsEnabled;
  }

  // Schedule appointment reminder
  Future<void> scheduleAppointmentReminder(Appointment appointment) async {
    if (!_notificationsEnabled || !_appointmentReminders) return;

    try {
      // Calculate reminder time (1 hour before appointment)
      final reminderTime = appointment.appointmentDate.subtract(const Duration(hours: 1));
      
      // In a real app, you would use a package like flutter_local_notifications
      debugPrint('Scheduling appointment reminder for: ${reminderTime.toString()}');
      
      // Mock scheduling
      await Future.delayed(const Duration(milliseconds: 100));
      
      debugPrint('Appointment reminder scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling appointment reminder: $e');
    }
  }

  // Schedule medication reminder
  Future<void> scheduleMedicationReminder(Task task) async {
    if (!_notificationsEnabled || !_medicationReminders) return;
    if (task.category != TaskCategory.medication) return;

    try {
      // Schedule reminder based on task due date
      if (task.dueDate != null) {
        debugPrint('Scheduling medication reminder for: ${task.dueDate.toString()}');
        
        // Mock scheduling
        await Future.delayed(const Duration(milliseconds: 100));
        
        debugPrint('Medication reminder scheduled successfully');
      }
    } catch (e) {
      debugPrint('Error scheduling medication reminder: $e');
    }
  }

  // Cancel appointment reminder
  Future<void> cancelAppointmentReminder(String appointmentId) async {
    try {
      debugPrint('Cancelling appointment reminder for: $appointmentId');
      
      // Mock cancellation
      await Future.delayed(const Duration(milliseconds: 50));
      
      debugPrint('Appointment reminder cancelled successfully');
    } catch (e) {
      debugPrint('Error cancelling appointment reminder: $e');
    }
  }

  // Cancel medication reminder
  Future<void> cancelMedicationReminder(String taskId) async {
    try {
      debugPrint('Cancelling medication reminder for: $taskId');
      
      // Mock cancellation
      await Future.delayed(const Duration(milliseconds: 50));
      
      debugPrint('Medication reminder cancelled successfully');
    } catch (e) {
      debugPrint('Error cancelling medication reminder: $e');
    }
  }

  // Send health tip notification
  Future<void> sendHealthTip(String tip) async {
    if (!_notificationsEnabled || !_healthTips) return;

    try {
      debugPrint('Sending health tip: $tip');
      
      // Mock sending
      await Future.delayed(const Duration(milliseconds: 100));
      
      debugPrint('Health tip sent successfully');
    } catch (e) {
      debugPrint('Error sending health tip: $e');
    }
  }

  // Get pending notifications count
  Future<int> getPendingNotificationsCount() async {
    try {
      // Mock getting count
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Return mock count
      return _notificationsEnabled ? 3 : 0;
    } catch (e) {
      debugPrint('Error getting pending notifications count: $e');
      return 0;
    }
  }

  // Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      debugPrint('Clearing all notifications');
      
      // Mock clearing
      await Future.delayed(const Duration(milliseconds: 100));
      
      debugPrint('All notifications cleared successfully');
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
  }

  // Initialize notification service
  Future<void> initialize() async {
    try {
      debugPrint('Initializing notification service');
      
      // Mock initialization
      await Future.delayed(const Duration(milliseconds: 200));
      
      debugPrint('Notification service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }

  // Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      debugPrint('Requesting notification permissions');
      
      // Mock permission request
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return mock permission granted
      debugPrint('Notification permissions granted');
      return true;
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      return false;
    }
  }

  // Check if notifications are supported
  bool get isSupported {
    // In a real app, check platform capabilities
    return true;
  }

  // Get notification settings summary
  Map<String, bool> getSettings() {
    return {
      'notificationsEnabled': _notificationsEnabled,
      'appointmentReminders': _appointmentReminders,
      'medicationReminders': _medicationReminders,
      'healthTips': _healthTips,
    };
  }

  // Update multiple settings at once
  void updateSettings(Map<String, bool> settings) {
    if (settings.containsKey('notificationsEnabled')) {
      setNotificationsEnabled(settings['notificationsEnabled']!);
    }
    if (settings.containsKey('appointmentReminders')) {
      setAppointmentReminders(settings['appointmentReminders']!);
    }
    if (settings.containsKey('medicationReminders')) {
      setMedicationReminders(settings['medicationReminders']!);
    }
    if (settings.containsKey('healthTips')) {
      setHealthTips(settings['healthTips']!);
    }
  }

  // Schedule daily health tips
  Future<void> scheduleDailyHealthTips() async {
    if (!_notificationsEnabled || !_healthTips) return;

    final healthTips = [
      'تذكر شرب 8 أكواب من الماء يومياً',
      'المشي لمدة 30 دقيقة يومياً مفيد لصحتك',
      'تناول 5 حصص من الفواكه والخضروات يومياً',
      'احرص على النوم 7-8 ساعات يومياً',
      'تجنب التدخين والكحول',
      'مارس تمارين التنفس للتخلص من التوتر',
      'احرص على الفحص الطبي الدوري',
    ];

    try {
      for (int i = 0; i < 7; i++) {
        final tip = healthTips[i % healthTips.length];
        // Schedule tip for next 7 days at 9 AM
        final scheduleTime = DateTime.now().add(Duration(days: i + 1));
        final tipTime = DateTime(scheduleTime.year, scheduleTime.month, scheduleTime.day, 9, 0);
        
        debugPrint('Scheduling health tip for: ${tipTime.toString()} - $tip');
      }
      
      debugPrint('Daily health tips scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling daily health tips: $e');
    }
  }

  // Handle notification tap
  void handleNotificationTap(String notificationId, Map<String, dynamic> payload) {
    debugPrint('Notification tapped: $notificationId with payload: $payload');
    
    // In a real app, navigate to appropriate screen based on payload
    final type = payload['type'] as String?;
    switch (type) {
      case 'appointment':
        debugPrint('Navigate to appointment details');
        break;
      case 'medication':
        debugPrint('Navigate to tasks screen');
        break;
      case 'health_tip':
        debugPrint('Navigate to health tips screen');
        break;
      default:
        debugPrint('Navigate to home screen');
    }
  }
}
