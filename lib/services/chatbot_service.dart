import '../database/database_helper.dart';
import '../models/chat_message.dart';
import 'package:uuid/uuid.dart';

class ChatbotService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();

  // Save a chat message
  Future<void> saveMessage(ChatMessage message) async {
    await _dbHelper.insert('chat_messages', message.toMap());
  }

  // Get chat history for a user
  Future<List<ChatMessage>> getChatHistory(String userId) async {
    final results = await _dbHelper.query(
      'chat_messages',
      where: 'conversation_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp ASC',
    );

    return results.map((map) => ChatMessage.fromMap(map)).toList();
  }

  // Get AI response to user message
  Future<String> getAIResponse(String userMessage, String userId) async {
    // This is a simple rule-based chatbot
    // In a real implementation, you would integrate with an AI service like OpenAI, Gemini, etc.
    
    final message = userMessage.toLowerCase().trim();
    
    // Symptom analysis patterns
    if (_containsSymptoms(message)) {
      return _analyzeSymptoms(message);
    }
    
    // Blood pressure related
    if (message.contains('ضغط') || message.contains('pressure')) {
      return _getBloodPressureAdvice(message);
    }
    
    // Blood sugar related
    if (message.contains('سكر') || message.contains('sugar') || message.contains('diabetes')) {
      return _getBloodSugarAdvice(message);
    }
    
    // Medication reminders
    if (message.contains('دواء') || message.contains('علاج') || message.contains('medication')) {
      return _getMedicationAdvice(message);
    }
    
    // Diet and nutrition
    if (message.contains('طعام') || message.contains('غذاء') || message.contains('diet') || message.contains('nutrition')) {
      return _getNutritionAdvice(message);
    }
    
    // Exercise and activity
    if (message.contains('رياضة') || message.contains('تمرين') || message.contains('exercise') || message.contains('activity')) {
      return _getExerciseAdvice(message);
    }
    
    // General health questions
    if (message.contains('صحة') || message.contains('health')) {
      return _getGeneralHealthAdvice(message);
    }
    
    // Appointment related
    if (message.contains('موعد') || message.contains('appointment') || message.contains('طبيب')) {
      return _getAppointmentAdvice(message);
    }
    
    // Default response
    return _getDefaultResponse();
  }

  bool _containsSymptoms(String message) {
    final symptoms = [
      'صداع', 'ألم', 'حمى', 'سعال', 'دوخة', 'غثيان', 'تعب', 'إرهاق',
      'headache', 'pain', 'fever', 'cough', 'dizziness', 'nausea', 'fatigue'
    ];
    
    return symptoms.any((symptom) => message.contains(symptom));
  }

  String _analyzeSymptoms(String message) {
    final responses = [
      '''أفهم أنك تعاني من بعض الأعراض. إليك بعض النصائح العامة:

🔍 **تحليل الأعراض:**
• سجل الأعراض ووقت ظهورها
• لاحظ شدة الأعراض من 1-10
• راقب أي عوامل محفزة

⚠️ **متى تستشير الطبيب:**
• إذا استمرت الأعراض أكثر من 3 أيام
• إذا ازدادت شدة الأعراض
• إذا ظهرت أعراض جديدة

💡 **نصائح عامة:**
• احصل على راحة كافية
• اشرب الكثير من الماء
• تجنب الإجهاد

⚕️ **تذكير مهم:** هذه نصائح عامة فقط. استشر طبيبك للتشخيص الدقيق.''',
    ];
    
    return responses.first;
  }

  String _getBloodPressureAdvice(String message) {
    return '''🫀 **نصائح لضغط الدم:**

📊 **القياس الصحيح:**
• قس ضغط الدم في نفس الوقت يومياً
• استرح 5 دقائق قبل القياس
• تجنب الكافيين قبل القياس بساعة

🥗 **النظام الغذائي:**
• قلل من الملح (أقل من 6 جرام يومياً)
• أكثر من الخضروات والفواكه
• تجنب الأطعمة المصنعة

🏃‍♂️ **النشاط البدني:**
• امش 30 دقيقة يومياً
• مارس تمارين التنفس
• تجنب التمارين الشاقة المفاجئة

💊 **الأدوية:**
• تناول الأدوية في مواعيدها
• لا تتوقف عن الدواء دون استشارة الطبيب

يمكنك تسجيل قياساتك في قسم "القياسات الطبية" في التطبيق.''';
  }

  String _getBloodSugarAdvice(String message) {
    return '''🩸 **نصائح لسكر الدم:**

📈 **المراقبة:**
• قس السكر حسب توجيهات طبيبك
• سجل القراءات مع الوقت والوجبات
• راقب أعراض انخفاض أو ارتفاع السكر

🍽️ **التغذية:**
• تناول وجبات منتظمة ومتوازنة
• قلل من السكريات البسيطة
• أكثر من الألياف والبروتين

⏰ **التوقيت:**
• لا تفوت الوجبات
• تناول وجبات خفيفة صحية عند الحاجة
• راقب مستوى السكر قبل النوم

🚨 **علامات التحذير:**
• السكر أقل من 70: تناول شيئاً حلواً فوراً
• السكر أعلى من 250: استشر الطبيب
• أعراض مثل العطش الشديد أو التبول المفرط

استخدم قسم "القياسات الطبية" لتتبع قراءاتك.''';
  }

  String _getMedicationAdvice(String message) {
    return '''💊 **نصائح الأدوية:**

⏰ **المواعيد:**
• تناول الأدوية في نفس الوقت يومياً
• استخدم منبهات للتذكير
• لا تفوت جرعات

📝 **التنظيم:**
• احتفظ بقائمة بجميع أدويتك
• اعرف أسماء الأدوية وجرعاتها
• أخبر جميع الأطباء بأدويتك

⚠️ **الأعراض الجانبية:**
• راقب أي أعراض غير طبيعية
• أبلغ طبيبك عن أي مشاكل
• لا تتوقف عن الدواء دون استشارة

🏪 **التخزين:**
• احفظ الأدوية في مكان بارد وجاف
• تحقق من تواريخ الانتهاء
• احتفظ بالأدوية في عبواتها الأصلية

يمكنك استخدام قسم "المهام" لتذكيرك بمواعيد الأدوية.''';
  }

  String _getNutritionAdvice(String message) {
    return '''🥗 **نصائح التغذية الصحية:**

🍎 **الأساسيات:**
• تناول 5 حصص من الخضروات والفواكه يومياً
• اختر الحبوب الكاملة
• أكثر من البروتين الخالي من الدهون

💧 **الترطيب:**
• اشرب 8-10 أكواب ماء يومياً
• قلل من المشروبات السكرية
• تجنب الكحول أو قلل منه

🧂 **ما يجب تجنبه:**
• الأطعمة المصنعة والمعلبة
• الدهون المشبعة والمتحولة
• السكريات المضافة

⏰ **التوقيت:**
• تناول 3 وجبات رئيسية و2 خفيفة
• لا تفوت وجبة الإفطار
• تجنب الأكل قبل النوم بساعتين

🍽️ **حجم الحصص:**
• استخدم أطباق أصغر
• امضغ ببطء
• توقف عند الشعور بالشبع''';
  }

  String _getExerciseAdvice(String message) {
    return '''🏃‍♂️ **نصائح النشاط البدني:**

⏰ **الهدف الأسبوعي:**
• 150 دقيقة من النشاط المعتدل
• أو 75 دقيقة من النشاط القوي
• تمارين القوة مرتين أسبوعياً

🚶‍♀️ **للمبتدئين:**
• ابدأ بالمشي 10 دقائق يومياً
• زد المدة تدريجياً
• اختر أنشطة تستمتع بها

💪 **أنواع التمارين:**
• تمارين القلب: المشي، السباحة، الدراجة
• تمارين القوة: رفع الأثقال، تمارين المقاومة
• تمارين المرونة: اليوغا، التمدد

⚠️ **احتياطات:**
• استشر طبيبك قبل بدء برنامج جديد
• ابدأ ببطء وزد التدريج
• توقف إذا شعرت بألم أو دوخة

🎯 **نصائح للاستمرار:**
• حدد أهدافاً واقعية
• مارس الرياضة مع صديق
• سجل تقدمك''';
  }

  String _getGeneralHealthAdvice(String message) {
    return '''🌟 **نصائح الصحة العامة:**

😴 **النوم:**
• احصل على 7-9 ساعات نوم يومياً
• حافظ على مواعيد نوم منتظمة
• تجنب الشاشات قبل النوم بساعة

🧘‍♀️ **إدارة التوتر:**
• مارس تمارين التنفس العميق
• جرب التأمل أو اليوغا
• خصص وقتاً للهوايات

🏥 **الفحوصات الدورية:**
• زر طبيبك بانتظام
• أجر الفحوصات المطلوبة
• راقب العلامات الحيوية

🚭 **العادات الصحية:**
• تجنب التدخين
• قلل من الكحول
• حافظ على وزن صحي

🤝 **الدعم الاجتماعي:**
• حافظ على علاقات إيجابية
• لا تتردد في طلب المساعدة
• شارك في أنشطة اجتماعية''';
  }

  String _getAppointmentAdvice(String message) {
    return '''📅 **نصائح المواعيد الطبية:**

🔍 **البحث عن طبيب:**
• استخدم قسم "البحث عن طبيب" في التطبيق
• اقرأ تقييمات المرضى
• تأكد من التخصص المناسب

📝 **التحضير للموعد:**
• اكتب أسئلتك مسبقاً
• أحضر قائمة بأدويتك
• سجل أعراضك وتواريخها

⏰ **إدارة المواعيد:**
• احجز مواعيدك مبكراً
• اصل قبل الموعد بـ15 دقيقة
• أكد موعدك قبل يوم

📊 **المتابعة:**
• احتفظ بتقاريرك الطبية
• اتبع تعليمات الطبيب
• احجز مواعيد المتابعة

يمكنك استخدام التطبيق لحجز المواعيد وتتبع تقاريرك الطبية.''';
  }

  String _getDefaultResponse() {
    final responses = [
      '''شكراً لك على سؤالك! 😊

أنا هنا لمساعدتك في:
• تحليل الأعراض وتقديم نصائح عامة
• معلومات عن ضغط الدم وسكر الدم
• نصائح التغذية والرياضة
• إرشادات الأدوية والعلاج
• معلومات عن المواعيد الطبية

يمكنك أيضاً استخدام ميزات التطبيق:
📊 تسجيل القياسات الطبية
🔍 البحث عن الأطباء
📅 حجز المواعيد
📋 مراجعة التقارير الصحية

كيف يمكنني مساعدتك اليوم؟''',
      
      '''أهلاً بك! 👋

لست متأكداً من فهم سؤالك بالضبط. يمكنني مساعدتك في:

🩺 **الصحة العامة:**
• تحليل الأعراض
• نصائح الوقاية
• معلومات طبية عامة

💊 **إدارة الأمراض المزمنة:**
• ضغط الدم
• السكري
• أمراض القلب

🥗 **نمط الحياة الصحي:**
• التغذية السليمة
• النشاط البدني
• إدارة التوتر

هل يمكنك إعادة صياغة سؤالك أو إخباري بما تحتاج مساعدة فيه تحديداً؟''',
    ];
    
    return responses[DateTime.now().millisecond % responses.length];
  }

  // Clear chat history
  Future<void> clearChatHistory(String userId) async {
    await _dbHelper.delete(
      'chat_messages',
      where: 'conversation_id = ?',
      whereArgs: [userId],
    );
  }

  // Get chat statistics
  Future<Map<String, int>> getChatStats(String userId) async {
    final db = await _dbHelper.database;
    
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM chat_messages WHERE conversation_id = ?',
      [userId],
    );
    
    final userMessagesResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM chat_messages WHERE conversation_id = ? AND is_user_message = 1',
      [userId],
    );
    
    final aiMessagesResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM chat_messages WHERE conversation_id = ? AND is_user_message = 0',
      [userId],
    );

    return {
      'total': totalResult.first['count'] as int,
      'userMessages': userMessagesResult.first['count'] as int,
      'aiMessages': aiMessagesResult.first['count'] as int,
    };
  }
}
