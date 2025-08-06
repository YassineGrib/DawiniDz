import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../utils/ui_helpers.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final NotificationService _notificationService = NotificationService();

  bool _notificationsEnabled = true;
  bool _appointmentReminders = true;
  bool _medicationReminders = true;
  bool _healthTips = false;
  bool _darkMode = false;
  String _selectedLanguage = 'العربية';

  final List<String> _languages = ['العربية', 'English', 'Français'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final settings = _notificationService.getSettings();
    setState(() {
      _notificationsEnabled = settings['notificationsEnabled'] ?? true;
      _appointmentReminders = settings['appointmentReminders'] ?? true;
      _medicationReminders = settings['medicationReminders'] ?? true;
      _healthTips = settings['healthTips'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الإعدادات'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Notifications Section
            _buildSection(
              title: 'الإشعارات',
              icon: Icons.notifications,
              children: [
                _buildSwitchTile(
                  title: 'تفعيل الإشعارات',
                  subtitle: 'تلقي جميع الإشعارات من التطبيق',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                      _notificationService.setNotificationsEnabled(value);
                      if (!value) {
                        _appointmentReminders = false;
                        _medicationReminders = false;
                        _healthTips = false;
                      }
                    });
                  },
                ),
                if (_notificationsEnabled) ...[
                  _buildSwitchTile(
                    title: 'تذكيرات المواعيد',
                    subtitle: 'تذكيرك بالمواعيد الطبية القادمة',
                    value: _appointmentReminders,
                    onChanged: (value) {
                      setState(() {
                        _appointmentReminders = value;
                        _notificationService.setAppointmentReminders(value);
                      });
                    },
                  ),
                  _buildSwitchTile(
                    title: 'تذكيرات الأدوية',
                    subtitle: 'تذكيرك بمواعيد تناول الأدوية',
                    value: _medicationReminders,
                    onChanged: (value) {
                      setState(() {
                        _medicationReminders = value;
                        _notificationService.setMedicationReminders(value);
                      });
                    },
                  ),
                  _buildSwitchTile(
                    title: 'نصائح صحية',
                    subtitle: 'تلقي نصائح صحية يومية',
                    value: _healthTips,
                    onChanged: (value) {
                      setState(() {
                        _healthTips = value;
                        _notificationService.setHealthTips(value);
                        if (value) {
                          _notificationService.scheduleDailyHealthTips();
                        }
                      });
                    },
                  ),
                ],
              ],
            ),

            const Divider(height: 1),

            // Appearance Section
            _buildSection(
              title: 'المظهر',
              icon: Icons.palette,
              children: [
                _buildSwitchTile(
                  title: 'الوضع الليلي',
                  subtitle: 'تفعيل المظهر الداكن للتطبيق',
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                    // TODO: Implement theme switching
                    UIHelpers.showWarningSnackBar(
                      context,
                      'سيتم تطبيق هذا الإعداد في التحديث القادم',
                    );
                  },
                ),
                _buildDropdownTile(
                  title: 'اللغة',
                  subtitle: 'اختيار لغة التطبيق',
                  value: _selectedLanguage,
                  items: _languages,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    if (value != 'العربية') {
                      UIHelpers.showWarningSnackBar(
                        context,
                        'سيتم دعم هذه اللغة في التحديث القادم',
                      );
                    }
                  },
                ),
              ],
            ),

            const Divider(height: 1),

            // Privacy & Security Section
            _buildSection(
              title: 'الخصوصية والأمان',
              icon: Icons.security,
              children: [
                _buildActionTile(
                  title: 'تغيير كلمة المرور',
                  subtitle: 'تحديث كلمة مرور الحساب',
                  icon: Icons.lock,
                  onTap: () {
                    // TODO: Navigate to change password screen
                    UIHelpers.showWarningSnackBar(
                      context,
                      'هذه الميزة قيد التطوير',
                    );
                  },
                ),
                _buildActionTile(
                  title: 'إعدادات الخصوصية',
                  subtitle: 'التحكم في مشاركة البيانات',
                  icon: Icons.privacy_tip,
                  onTap: () {
                    _showPrivacySettings();
                  },
                ),
                _buildActionTile(
                  title: 'تصدير البيانات',
                  subtitle: 'تحميل نسخة من بياناتك',
                  icon: Icons.download,
                  onTap: () {
                    _exportData();
                  },
                ),
              ],
            ),

            const Divider(height: 1),

            // Data & Storage Section
            _buildSection(
              title: 'البيانات والتخزين',
              icon: Icons.storage,
              children: [
                _buildActionTile(
                  title: 'مسح البيانات المؤقتة',
                  subtitle: 'حذف الملفات المؤقتة لتوفير مساحة',
                  icon: Icons.cleaning_services,
                  onTap: () {
                    _clearCache();
                  },
                ),
                _buildActionTile(
                  title: 'النسخ الاحتياطي',
                  subtitle: 'إنشاء نسخة احتياطية من البيانات',
                  icon: Icons.backup,
                  onTap: () {
                    _createBackup();
                  },
                ),
              ],
            ),

            const Divider(height: 1),

            // About Section
            _buildSection(
              title: 'حول التطبيق',
              icon: Icons.info,
              children: [
                _buildActionTile(
                  title: 'الشروط والأحكام',
                  subtitle: 'قراءة شروط استخدام التطبيق',
                  icon: Icons.description,
                  onTap: () {
                    // TODO: Navigate to terms screen
                  },
                ),
                _buildActionTile(
                  title: 'سياسة الخصوصية',
                  subtitle: 'معرفة كيفية حماية بياناتك',
                  icon: Icons.policy,
                  onTap: () {
                    // TODO: Navigate to privacy policy screen
                  },
                ),
                _buildActionTile(
                  title: 'تقييم التطبيق',
                  subtitle: 'ساعدنا في تحسين التطبيق',
                  icon: Icons.star,
                  onTap: () {
                    _rateApp();
                  },
                ),
                _buildInfoTile(
                  title: 'إصدار التطبيق',
                  subtitle: '1.0.0',
                  icon: Icons.info_outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          color: Colors.grey[50],
          child: Row(
            children: [
              Icon(icon, color: AppConstants.primaryColor, size: 20),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          color: AppConstants.textSecondaryColor,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppConstants.primaryColor,
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          color: AppConstants.textSecondaryColor,
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.textPrimaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          color: AppConstants.textSecondaryColor,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppConstants.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.textSecondaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        subtitle,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          color: AppConstants.textSecondaryColor,
        ),
      ),
    );
  }

  void _showPrivacySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعدادات الخصوصية'),
        content: const Text(
          'يمكنك التحكم في مشاركة بياناتك الصحية مع الأطباء والمؤسسات الطبية.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _exportData() async {
    UIHelpers.showLoadingDialog(context, message: 'جاري تصدير البيانات...');

    // Simulate export process
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      UIHelpers.hideLoadingDialog(context);
      UIHelpers.showSuccessSnackBar(context, 'تم تصدير البيانات بنجاح');
    }
  }

  void _clearCache() async {
    final confirmed = await UIHelpers.showConfirmationDialog(
      context,
      title: 'مسح البيانات المؤقتة',
      message: 'هل أنت متأكد من مسح البيانات المؤقتة؟',
    );

    if (confirmed == true) {
      UIHelpers.showLoadingDialog(context, message: 'جاري مسح البيانات...');

      // Simulate cache clearing
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        UIHelpers.hideLoadingDialog(context);
        UIHelpers.showSuccessSnackBar(context, 'تم مسح البيانات المؤقتة');
      }
    }
  }

  void _createBackup() async {
    UIHelpers.showLoadingDialog(
      context,
      message: 'جاري إنشاء النسخة الاحتياطية...',
    );

    // Simulate backup process
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      UIHelpers.hideLoadingDialog(context);
      UIHelpers.showSuccessSnackBar(
        context,
        'تم إنشاء النسخة الاحتياطية بنجاح',
      );
    }
  }

  void _rateApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تقييم التطبيق'),
        content: const Text(
          'شكراً لاستخدامك دويني دي زد! يرجى تقييم التطبيق في متجر التطبيقات.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('لاحقاً'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Open app store for rating
            },
            child: const Text('تقييم الآن'),
          ),
        ],
      ),
    );
  }
}
