import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ar', 'DZ'), // Arabic (Algeria)
    Locale('en', 'US'), // English (US)
    Locale('fr', 'FR'), // French (France)
  ];

  // App General
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get filter => _localizedValues[locale.languageCode]!['filter']!;
  String get refresh => _localizedValues[locale.languageCode]!['refresh']!;
  String get back => _localizedValues[locale.languageCode]!['back']!;
  String get next => _localizedValues[locale.languageCode]!['next']!;
  String get previous => _localizedValues[locale.languageCode]!['previous']!;
  String get done => _localizedValues[locale.languageCode]!['done']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;

  // Authentication
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get register => _localizedValues[locale.languageCode]!['register']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get confirmPassword => _localizedValues[locale.languageCode]!['confirm_password']!;
  String get fullName => _localizedValues[locale.languageCode]!['full_name']!;
  String get phone => _localizedValues[locale.languageCode]!['phone']!;
  String get forgotPassword => _localizedValues[locale.languageCode]!['forgot_password']!;

  // Navigation
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get appointments => _localizedValues[locale.languageCode]!['appointments']!;
  String get measurements => _localizedValues[locale.languageCode]!['measurements']!;
  String get reports => _localizedValues[locale.languageCode]!['reports']!;
  String get tasks => _localizedValues[locale.languageCode]!['tasks']!;
  String get chat => _localizedValues[locale.languageCode]!['chat']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;

  // Doctors
  String get doctors => _localizedValues[locale.languageCode]!['doctors']!;
  String get findDoctor => _localizedValues[locale.languageCode]!['find_doctor']!;
  String get specialty => _localizedValues[locale.languageCode]!['specialty']!;
  String get location => _localizedValues[locale.languageCode]!['location']!;
  String get rating => _localizedValues[locale.languageCode]!['rating']!;
  String get experience => _localizedValues[locale.languageCode]!['experience']!;
  String get consultationFee => _localizedValues[locale.languageCode]!['consultation_fee']!;
  String get available => _localizedValues[locale.languageCode]!['available']!;
  String get unavailable => _localizedValues[locale.languageCode]!['unavailable']!;

  // Appointments
  String get bookAppointment => _localizedValues[locale.languageCode]!['book_appointment']!;
  String get appointmentDate => _localizedValues[locale.languageCode]!['appointment_date']!;
  String get appointmentTime => _localizedValues[locale.languageCode]!['appointment_time']!;
  String get upcomingAppointments => _localizedValues[locale.languageCode]!['upcoming_appointments']!;
  String get pastAppointments => _localizedValues[locale.languageCode]!['past_appointments']!;
  String get appointmentBooked => _localizedValues[locale.languageCode]!['appointment_booked']!;
  String get appointmentCancelled => _localizedValues[locale.languageCode]!['appointment_cancelled']!;

  // Medical Measurements
  String get bloodPressure => _localizedValues[locale.languageCode]!['blood_pressure']!;
  String get bloodSugar => _localizedValues[locale.languageCode]!['blood_sugar']!;
  String get systolic => _localizedValues[locale.languageCode]!['systolic']!;
  String get diastolic => _localizedValues[locale.languageCode]!['diastolic']!;
  String get measurementDate => _localizedValues[locale.languageCode]!['measurement_date']!;
  String get measurementTime => _localizedValues[locale.languageCode]!['measurement_time']!;
  String get addMeasurement => _localizedValues[locale.languageCode]!['add_measurement']!;
  String get measurementSaved => _localizedValues[locale.languageCode]!['measurement_saved']!;

  // Health Reports
  String get healthReports => _localizedValues[locale.languageCode]!['health_reports']!;
  String get reportTitle => _localizedValues[locale.languageCode]!['report_title']!;
  String get interpretation => _localizedValues[locale.languageCode]!['interpretation']!;
  String get medicalNotes => _localizedValues[locale.languageCode]!['medical_notes']!;
  String get nutritionAdvice => _localizedValues[locale.languageCode]!['nutrition_advice']!;
  String get activityAdvice => _localizedValues[locale.languageCode]!['activity_advice']!;
  String get treatmentModifications => _localizedValues[locale.languageCode]!['treatment_modifications']!;
  String get nextCheckup => _localizedValues[locale.languageCode]!['next_checkup']!;

  // Tasks
  String get myTasks => _localizedValues[locale.languageCode]!['my_tasks']!;
  String get addTask => _localizedValues[locale.languageCode]!['add_task']!;
  String get taskTitle => _localizedValues[locale.languageCode]!['task_title']!;
  String get taskDescription => _localizedValues[locale.languageCode]!['task_description']!;
  String get dueDate => _localizedValues[locale.languageCode]!['due_date']!;
  String get priority => _localizedValues[locale.languageCode]!['priority']!;
  String get category => _localizedValues[locale.languageCode]!['category']!;
  String get status => _localizedValues[locale.languageCode]!['status']!;
  String get completedTasks => _localizedValues[locale.languageCode]!['completed_tasks']!;
  String get pendingTasks => _localizedValues[locale.languageCode]!['pending_tasks']!;

  // Chat
  String get healthAssistant => _localizedValues[locale.languageCode]!['health_assistant']!;
  String get askQuestion => _localizedValues[locale.languageCode]!['ask_question']!;
  String get symptoms => _localizedValues[locale.languageCode]!['symptoms']!;
  String get describeSymptoms => _localizedValues[locale.languageCode]!['describe_symptoms']!;
  String get preliminaryDiagnosis => _localizedValues[locale.languageCode]!['preliminary_diagnosis']!;
  String get recommendations => _localizedValues[locale.languageCode]!['recommendations']!;
  String get chatHistory => _localizedValues[locale.languageCode]!['chat_history']!;

  // Profile
  String get myProfile => _localizedValues[locale.languageCode]!['my_profile']!;
  String get personalInfo => _localizedValues[locale.languageCode]!['personal_info']!;
  String get dateOfBirth => _localizedValues[locale.languageCode]!['date_of_birth']!;
  String get gender => _localizedValues[locale.languageCode]!['gender']!;
  String get address => _localizedValues[locale.languageCode]!['address']!;
  String get wilaya => _localizedValues[locale.languageCode]!['wilaya']!;
  String get commune => _localizedValues[locale.languageCode]!['commune']!;
  String get profileUpdated => _localizedValues[locale.languageCode]!['profile_updated']!;

  // Validation Messages
  String get fieldRequired => _localizedValues[locale.languageCode]!['field_required']!;
  String get invalidEmail => _localizedValues[locale.languageCode]!['invalid_email']!;
  String get passwordTooShort => _localizedValues[locale.languageCode]!['password_too_short']!;
  String get passwordsDoNotMatch => _localizedValues[locale.languageCode]!['passwords_do_not_match']!;
  String get invalidPhoneNumber => _localizedValues[locale.languageCode]!['invalid_phone_number']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      // App General
      'app_name': 'دويني دي زد',
      'welcome': 'مرحباً',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'search': 'بحث',
      'filter': 'تصفية',
      'refresh': 'تحديث',
      'back': 'رجوع',
      'next': 'التالي',
      'previous': 'السابق',
      'done': 'تم',
      'close': 'إغلاق',

      // Authentication
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'logout': 'تسجيل الخروج',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'full_name': 'الاسم الكامل',
      'phone': 'رقم الهاتف',
      'forgot_password': 'نسيت كلمة المرور؟',

      // Navigation
      'home': 'الرئيسية',
      'appointments': 'المواعيد',
      'measurements': 'القياسات',
      'reports': 'التقارير',
      'tasks': 'المهام',
      'chat': 'المساعد الصحي',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',

      // Doctors
      'doctors': 'الأطباء',
      'find_doctor': 'البحث عن طبيب',
      'specialty': 'التخصص',
      'location': 'الموقع',
      'rating': 'التقييم',
      'experience': 'سنوات الخبرة',
      'consultation_fee': 'رسوم الاستشارة',
      'available': 'متاح',
      'unavailable': 'غير متاح',

      // Appointments
      'book_appointment': 'حجز موعد',
      'appointment_date': 'تاريخ الموعد',
      'appointment_time': 'وقت الموعد',
      'upcoming_appointments': 'المواعيد القادمة',
      'past_appointments': 'المواعيد السابقة',
      'appointment_booked': 'تم حجز الموعد بنجاح',
      'appointment_cancelled': 'تم إلغاء الموعد',

      // Medical Measurements
      'blood_pressure': 'ضغط الدم',
      'blood_sugar': 'سكر الدم',
      'systolic': 'الانقباضي',
      'diastolic': 'الانبساطي',
      'measurement_date': 'تاريخ القياس',
      'measurement_time': 'وقت القياس',
      'add_measurement': 'إضافة قياس',
      'measurement_saved': 'تم حفظ القياس',

      // Health Reports
      'health_reports': 'التقارير الصحية',
      'report_title': 'عنوان التقرير',
      'interpretation': 'التفسير',
      'medical_notes': 'الملاحظات الطبية',
      'nutrition_advice': 'نصائح التغذية',
      'activity_advice': 'نصائح النشاط',
      'treatment_modifications': 'تعديلات العلاج',
      'next_checkup': 'الفحص القادم',

      // Tasks
      'my_tasks': 'مهامي',
      'add_task': 'إضافة مهمة',
      'task_title': 'عنوان المهمة',
      'task_description': 'وصف المهمة',
      'due_date': 'تاريخ الاستحقاق',
      'priority': 'الأولوية',
      'category': 'الفئة',
      'status': 'الحالة',
      'completed_tasks': 'المهام المكتملة',
      'pending_tasks': 'المهام المعلقة',

      // Chat
      'health_assistant': 'المساعد الصحي',
      'ask_question': 'اسأل سؤالاً',
      'symptoms': 'الأعراض',
      'describe_symptoms': 'صف الأعراض التي تشعر بها',
      'preliminary_diagnosis': 'التشخيص الأولي',
      'recommendations': 'التوصيات',
      'chat_history': 'سجل المحادثات',

      // Profile
      'my_profile': 'ملفي الشخصي',
      'personal_info': 'المعلومات الشخصية',
      'date_of_birth': 'تاريخ الميلاد',
      'gender': 'الجنس',
      'address': 'العنوان',
      'wilaya': 'الولاية',
      'commune': 'البلدية',
      'profile_updated': 'تم تحديث الملف الشخصي',

      // Validation Messages
      'field_required': 'هذا الحقل مطلوب',
      'invalid_email': 'البريد الإلكتروني غير صحيح',
      'password_too_short': 'كلمة المرور قصيرة جداً',
      'passwords_do_not_match': 'كلمات المرور غير متطابقة',
      'invalid_phone_number': 'رقم الهاتف غير صحيح',
    },
    'en': {
      // App General
      'app_name': 'DawiniDz',
      'welcome': 'Welcome',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'search': 'Search',
      'filter': 'Filter',
      'refresh': 'Refresh',
      'back': 'Back',
      'next': 'Next',
      'previous': 'Previous',
      'done': 'Done',
      'close': 'Close',

      // Authentication
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'phone': 'Phone Number',
      'forgot_password': 'Forgot Password?',

      // Navigation
      'home': 'Home',
      'appointments': 'Appointments',
      'measurements': 'Measurements',
      'reports': 'Reports',
      'tasks': 'Tasks',
      'chat': 'Health Assistant',
      'profile': 'Profile',
      'settings': 'Settings',

      // Add more English translations as needed...
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
