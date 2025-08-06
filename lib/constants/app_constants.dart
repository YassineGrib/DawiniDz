import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'DawiniDz';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Comprehensive Medical Appointment and Health Management App for Algeria';

  // Colors
  static const Color primaryColor = Color(0xFF2E7D32); // Medical Green
  static const Color secondaryColor = Color(0xFF1976D2); // Medical Blue
  static const Color accentColor = Color(0xFFFF6B35); // Orange accent
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeTitle = 24.0;
  static const double fontSizeHeading = 28.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);

  // Medical Specialties in Arabic
  static const List<String> medicalSpecialties = [
    'طب عام', // General Medicine
    'طب الأطفال', // Pediatrics
    'طب النساء والتوليد', // Gynecology & Obstetrics
    'طب القلب', // Cardiology
    'طب الأعصاب', // Neurology
    'طب العظام', // Orthopedics
    'طب الجلدية', // Dermatology
    'طب العيون', // Ophthalmology
    'طب الأنف والأذن والحنجرة', // ENT
    'طب الأسنان', // Dentistry
    'الطب النفسي', // Psychiatry
    'طب المسالك البولية', // Urology
    'طب الجهاز الهضمي', // Gastroenterology
    'طب الغدد الصماء', // Endocrinology
    'طب الروماتيزم', // Rheumatology
    'طب الأورام', // Oncology
    'طب الطوارئ', // Emergency Medicine
    'طب التخدير', // Anesthesiology
    'الأشعة', // Radiology
    'المختبرات الطبية', // Laboratory Medicine
  ];

  // Algeria Wilayas (Provinces)
  static const List<String> algeriaWilayas = [
    'أدرار', // Adrar
    'الشلف', // Chlef
    'الأغواط', // Laghouat
    'أم البواقي', // Oum El Bouaghi
    'باتنة', // Batna
    'بجاية', // Béjaïa
    'بسكرة', // Biskra
    'بشار', // Béchar
    'البليدة', // Blida
    'البويرة', // Bouira
    'تمنراست', // Tamanrasset
    'تبسة', // Tébessa
    'تلمسان', // Tlemcen
    'تيارت', // Tiaret
    'تيزي وزو', // Tizi Ouzou
    'الجزائر', // Algiers
    'الجلفة', // Djelfa
    'جيجل', // Jijel
    'سطيف', // Sétif
    'سعيدة', // Saïda
    'سكيكدة', // Skikda
    'سيدي بلعباس', // Sidi Bel Abbès
    'عنابة', // Annaba
    'قالمة', // Guelma
    'قسنطينة', // Constantine
    'المدية', // Médéa
    'مستغانم', // Mostaganem
    'المسيلة', // M'Sila
    'معسكر', // Mascara
    'ورقلة', // Ouargla
    'وهران', // Oran
    'البيض', // El Bayadh
    'إليزي', // Illizi
    'برج بوعريريج', // Bordj Bou Arréridj
    'بومرداس', // Boumerdès
    'الطارف', // El Tarf
    'تندوف', // Tindouf
    'تيسمسيلت', // Tissemsilt
    'الوادي', // El Oued
    'خنشلة', // Khenchela
    'سوق أهراس', // Souk Ahras
    'تيبازة', // Tipaza
    'ميلة', // Mila
    'عين الدفلى', // Aïn Defla
    'النعامة', // Naâma
    'عين تموشنت', // Aïn Témouchent
    'غرداية', // Ghardaïa
    'غليزان', // Relizane
    'تيميمون', // Timimoun
    'برج باجي مختار', // Bordj Badji Mokhtar
    'أولاد جلال', // Ouled Djellal
    'بني عباس', // Béni Abbès
    'إن صالح', // In Salah
    'إن قزام', // In Guezzam
    'توقرت', // Touggourt
    'جانت', // Djanet
    'المغير', // El M'Ghair
    'المنيعة', // El Meniaa
  ];

  // Task Categories in Arabic
  static const Map<String, String> taskCategories = {
    'general': 'عام',
    'medical': 'طبي',
    'appointment': 'موعد',
    'medication': 'دواء',
    'exercise': 'تمارين',
    'diet': 'نظام غذائي',
  };

  // Task Priorities in Arabic
  static const Map<String, String> taskPriorities = {
    'low': 'منخفض',
    'medium': 'متوسط',
    'high': 'عالي',
    'urgent': 'عاجل',
  };

  // Task Status in Arabic
  static const Map<String, String> taskStatus = {
    'pending': 'في الانتظار',
    'inProgress': 'قيد التنفيذ',
    'completed': 'مكتمل',
    'cancelled': 'ملغي',
    'overdue': 'متأخر',
  };

  // Appointment Status in Arabic
  static const Map<String, String> appointmentStatus = {
    'scheduled': 'مجدول',
    'confirmed': 'مؤكد',
    'completed': 'مكتمل',
    'cancelled': 'ملغي',
    'rescheduled': 'معاد جدولته',
  };

  // Blood Pressure Categories
  static const Map<String, String> bloodPressureCategories = {
    'normal': 'طبيعي',
    'elevated': 'مرتفع قليلاً',
    'high_stage1': 'ارتفاع المرحلة الأولى',
    'high_stage2': 'ارتفاع المرحلة الثانية',
    'crisis': 'أزمة ارتفاع ضغط',
  };

  // Blood Sugar Categories
  static const Map<String, String> bloodSugarCategories = {
    'low': 'منخفض',
    'normal': 'طبيعي',
    'prediabetes': 'ما قبل السكري',
    'diabetes': 'سكري',
  };

  // Common Symptoms in Arabic
  static const List<String> commonSymptoms = [
    'صداع',
    'حمى',
    'سعال',
    'ألم في الصدر',
    'ضيق في التنفس',
    'ألم في البطن',
    'غثيان',
    'قيء',
    'إسهال',
    'إمساك',
    'دوخة',
    'تعب',
    'ألم في المفاصل',
    'ألم في العضلات',
    'طفح جلدي',
    'حكة',
    'فقدان الشهية',
    'فقدان الوزن',
    'زيادة الوزن',
    'اضطرابات النوم',
  ];

  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.dawinidz.com';
  static const String authEndpoint = '/auth';
  static const String doctorsEndpoint = '/doctors';
  static const String appointmentsEndpoint = '/appointments';
  static const String measurementsEndpoint = '/measurements';
  static const String reportsEndpoint = '/reports';
  static const String chatEndpoint = '/chat';

  // Shared Preferences Keys
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';
  static const String keyNotifications = 'notifications_enabled';

  // Database Tables
  static const String tableUsers = 'users';
  static const String tableDoctors = 'doctors';
  static const String tableAppointments = 'appointments';
  static const String tableMeasurements = 'medical_measurements';
  static const String tableReports = 'health_reports';
  static const String tableTasks = 'tasks';
  static const String tableChatConversations = 'chat_conversations';
  static const String tableChatMessages = 'chat_messages';
}
