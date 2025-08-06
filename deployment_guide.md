# دليل النشر - DawiniDz Deployment Guide

## 📋 قائمة التحقق قبل النشر

### ✅ الاختبارات
- [ ] تشغيل جميع اختبارات الوحدة
- [ ] تشغيل اختبارات التكامل
- [ ] اختبار التطبيق على أجهزة مختلفة
- [ ] اختبار الأداء والذاكرة
- [ ] اختبار الاتصال بقاعدة البيانات

### ✅ الأمان
- [ ] مراجعة أذونات التطبيق
- [ ] تشفير البيانات الحساسة
- [ ] التحقق من عدم وجود مفاتيح API مكشوفة
- [ ] مراجعة إعدادات الشبكة

### ✅ الأداء
- [ ] تحسين حجم التطبيق
- [ ] ضغط الصور والموارد
- [ ] تحسين استعلامات قاعدة البيانات
- [ ] اختبار الأداء على أجهزة ضعيفة

## 🤖 نشر Android

### إعداد التوقيع

1. **إنشاء مفتاح التوقيع**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **إعداد ملف key.properties**
```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<location of the key store file>
```

3. **تحديث android/app/build.gradle**
```gradle
android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### بناء APK للإنتاج
```bash
flutter build apk --release
```

### بناء App Bundle للإنتاج
```bash
flutter build appbundle --release
```

### رفع إلى Google Play Store

1. إنشاء حساب مطور على Google Play Console
2. إنشاء تطبيق جديد
3. رفع App Bundle
4. إكمال معلومات التطبيق
5. إعداد الاختبار الداخلي
6. مراجعة ونشر التطبيق

## 🍎 نشر iOS

### إعداد Xcode

1. **فتح المشروع في Xcode**
```bash
open ios/Runner.xcworkspace
```

2. **إعداد Team وBundle Identifier**
3. **إعداد شهادات التوقيع**

### بناء للإنتاج
```bash
flutter build ios --release
```

### رفع إلى App Store

1. استخدام Xcode لرفع التطبيق
2. إكمال معلومات التطبيق في App Store Connect
3. إعداد TestFlight للاختبار
4. إرسال للمراجعة

## 🌐 إعداد الخادم (اختياري)

### متطلبات الخادم
- Node.js أو Python للـ Backend API
- PostgreSQL أو MySQL لقاعدة البيانات
- Redis للتخزين المؤقت
- SSL Certificate للأمان

### إعداد قاعدة البيانات السحابية
```sql
-- إنشاء جداول قاعدة البيانات
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(36) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- إضافة الجداول الأخرى...
```

## 📊 مراقبة التطبيق

### إعداد Firebase Analytics
```dart
// في main.dart
import 'package:firebase_analytics/firebase_analytics.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  runApp(MyApp());
}
```

### إعداد Crashlytics
```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  runApp(MyApp());
}
```

## 🔄 التحديثات المستقبلية

### استراتيجية التحديث
1. **تحديثات الأمان**: فورية
2. **إصلاح الأخطاء**: أسبوعية
3. **ميزات جديدة**: شهرية
4. **تحديثات كبيرة**: ربع سنوية

### إدارة الإصدارات
```bash
# تحديث رقم الإصدار
flutter pub run build_runner build

# إنشاء tag للإصدار
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## 🚨 خطة الطوارئ

### في حالة مشاكل الإنتاج
1. **تحديد المشكلة**: مراجعة logs والتقارير
2. **إصلاح سريع**: hotfix إذا أمكن
3. **الرجوع للإصدار السابق**: إذا لزم الأمر
4. **التواصل**: إعلام المستخدمين عبر التطبيق

### نسخ احتياطية
- نسخ احتياطية يومية لقاعدة البيانات
- نسخ احتياطية أسبوعية للملفات
- اختبار استعادة البيانات شهرياً

## 📈 مقاييس النجاح

### مؤشرات الأداء الرئيسية (KPIs)
- عدد التحميلات
- معدل الاحتفاظ بالمستخدمين
- تقييمات المتجر
- وقت استجابة التطبيق
- معدل الأخطاء

### أدوات المراقبة
- Google Analytics
- Firebase Performance
- Crashlytics
- App Store Connect Analytics
- Google Play Console

## 🔧 الصيانة

### مهام الصيانة الدورية
- **يومياً**: مراجعة logs والأخطاء
- **أسبوعياً**: تحديث التبعيات
- **شهرياً**: مراجعة الأداء والأمان
- **ربع سنوياً**: مراجعة شاملة للكود

### تحديث التبعيات
```bash
flutter pub upgrade
flutter pub outdated
```

## 📞 الدعم الفني

### قنوات الدعم
- البريد الإلكتروني: support@dawinidz.com
- نظام التذاكر: help.dawinidz.com
- الدردشة المباشرة: داخل التطبيق
- وسائل التواصل الاجتماعي

### أوقات الاستجابة
- مشاكل حرجة: خلال ساعة
- مشاكل عادية: خلال 24 ساعة
- استفسارات عامة: خلال 48 ساعة

---

**ملاحظة**: هذا الدليل يجب تحديثه مع كل إصدار جديد من التطبيق.
