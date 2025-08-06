import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class FontTestScreen extends StatelessWidget {
  const FontTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'اختبار خط تجوال',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'اختبار خط تجوال (Tajawal Font Test)',
              style: TextStyle(
                fontSize: AppConstants.fontSizeHeading,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Different font weights
            _buildFontSample('خط تجوال - خفيف', FontWeight.w300, 'Tajawal Light'),
            _buildFontSample('خط تجوال - عادي', FontWeight.w400, 'Tajawal Regular'),
            _buildFontSample('خط تجوال - متوسط', FontWeight.w500, 'Tajawal Medium'),
            _buildFontSample('خط تجوال - عريض', FontWeight.w700, 'Tajawal Bold'),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Sample medical text
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نص طبي تجريبي',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXLarge,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    const Text(
                      'مرحباً بكم في تطبيق دويني دي زد، التطبيق الشامل لإدارة المواعيد الطبية والصحة في الجزائر. يمكنكم من خلال هذا التطبيق البحث عن الأطباء، حجز المواعيد، تسجيل القياسات الطبية، والحصول على التقارير الصحية.',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    const Text(
                      'التخصصات الطبية المتوفرة:',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    ...AppConstants.medicalSpecialties.take(5).map((specialty) => 
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '• $specialty',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Numbers and mixed text
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الأرقام والنصوص المختلطة',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXLarge,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    const Text(
                      'ضغط الدم: 120/80 mmHg',
                      style: TextStyle(fontSize: AppConstants.fontSizeMedium),
                    ),
                    const Text(
                      'سكر الدم: 95.5 mg/dL',
                      style: TextStyle(fontSize: AppConstants.fontSizeMedium),
                    ),
                    const Text(
                      'الوزن: 70.2 كيلوغرام',
                      style: TextStyle(fontSize: AppConstants.fontSizeMedium),
                    ),
                    const Text(
                      'الطول: 175 سنتيمتر',
                      style: TextStyle(fontSize: AppConstants.fontSizeMedium),
                    ),
                    const Text(
                      'رقم الهاتف: 0555123456',
                      style: TextStyle(fontSize: AppConstants.fontSizeMedium),
                    ),
                    const Text(
                      'البريد الإلكتروني: user@example.com',
                      style: TextStyle(fontSize: AppConstants.fontSizeMedium),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Button with Tajawal font
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم اختبار الخط بنجاح!'),
                    ),
                  );
                },
                child: const Text('اختبار الزر بخط تجوال'),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('العودة للصفحة الرئيسية'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSample(String arabicText, FontWeight weight, String englishText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            arabicText,
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: weight,
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            englishText,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: AppConstants.textSecondaryColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
        ],
      ),
    );
  }
}
