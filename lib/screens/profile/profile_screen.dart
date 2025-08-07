import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../../utils/ui_helpers.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;
  Map<String, int> _userStats = {};

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUserStats();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Initialize auth service and get current user
      await _authService.initialize();
      final user = _authService.currentUser;

      setState(() {
        _currentUser = user;
        _isLoading = false;
      });

      if (user == null) {
        // No user logged in, redirect to login
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        UIHelpers.showErrorSnackBar(
          context,
          'خطأ في تحميل الملف الشخصي: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _loadUserStats() async {
    try {
      // TODO: Implement actual stats loading from services
      setState(() {
        _userStats = {
          'appointments': 12,
          'measurements': 45,
          'reports': 8,
          'tasks': 23,
        };
      });
    } catch (e) {
      debugPrint('Error loading user stats: $e');
    }
  }

  Future<void> _changeProfileImage() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('اختيار من المعرض'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 512,
                  maxHeight: 512,
                  imageQuality: 80,
                );
                if (image != null) {
                  await _updateProfileImage(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('التقاط صورة'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 512,
                  maxHeight: 512,
                  imageQuality: 80,
                );
                if (image != null) {
                  await _updateProfileImage(image.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfileImage(String imagePath) async {
    try {
      if (_currentUser != null) {
        await _userService.updateProfileImage(_currentUser!.uuid, imagePath);
        await _loadUserProfile(); // Reload profile
        if (mounted) {
          UIHelpers.showSuccessSnackBar(context, 'تم تحديث الصورة الشخصية');
        }
      }
    } catch (e) {
      if (mounted) {
        UIHelpers.showErrorSnackBar(context, 'خطأ في تحديث الصورة');
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await UIHelpers.showConfirmationDialog(
      context,
      title: 'تسجيل الخروج',
      message: 'هل أنت متأكد من تسجيل الخروج؟',
      confirmText: 'تسجيل الخروج',
      confirmColor: AppConstants.errorColor,
    );

    if (confirmed == true && mounted) {
      try {
        // Show loading
        UIHelpers.showLoadingDialog(context, message: 'جاري تسجيل الخروج...');

        // Clear auth data
        await _authService.logout();

        // Hide loading
        if (mounted) {
          UIHelpers.hideLoadingDialog(context);

          // Navigate to login screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );

          // Show success message
          UIHelpers.showSuccessSnackBar(context, 'تم تسجيل الخروج بنجاح');
        }
      } catch (e) {
        if (mounted) {
          UIHelpers.hideLoadingDialog(context);
          UIHelpers.showErrorSnackBar(
            context,
            'خطأ في تسجيل الخروج: ${e.toString()}',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الملف الشخصي', showBackButton: false),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
          ? _buildErrorState()
          : _buildProfileContent(),
    );
  }

  Widget _buildErrorState() {
    return UIHelpers.buildEmptyState(
      icon: Icons.error_outline,
      title: 'خطأ في تحميل الملف الشخصي',
      subtitle: 'تعذر تحميل بيانات المستخدم',
      action: ElevatedButton(
        onPressed: _loadUserProfile,
        child: const Text('إعادة المحاولة'),
      ),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        children: [
          // Profile Header
          _buildProfileHeader(),

          const SizedBox(height: AppConstants.paddingLarge),

          // User Stats
          _buildUserStats(),

          const SizedBox(height: AppConstants.paddingLarge),

          // Profile Options
          _buildProfileOptions(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            // Profile Image
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppConstants.primaryColor.withValues(
                    alpha: 0.1,
                  ),
                  backgroundImage: _currentUser!.profileImage != null
                      ? FileImage(File(_currentUser!.profileImage!))
                      : null,
                  child: _currentUser!.profileImage == null
                      ? Text(
                          _currentUser!.fullName
                              .split(' ')
                              .first
                              .substring(0, 1),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryColor,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _changeProfileImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppConstants.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // User Name
            Text(
              _currentUser!.fullName,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
              ),
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            // User Email
            Text(
              _currentUser!.email,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.textSecondaryColor,
              ),
            ),

            if (_currentUser!.phone != null) ...[
              const SizedBox(height: AppConstants.paddingSmall / 2),
              Text(
                _currentUser!.phone!,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textSecondaryColor,
                ),
              ),
            ],

            const SizedBox(height: AppConstants.paddingMedium),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(user: _currentUser!),
                        ),
                      )
                      .then((_) => _loadUserProfile());
                },
                icon: const Icon(Icons.edit),
                label: const Text('تعديل الملف الشخصي'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إحصائياتي',
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.calendar_today,
                    label: 'المواعيد',
                    value: _userStats['appointments']?.toString() ?? '0',
                    color: AppConstants.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.monitor_heart,
                    label: 'القياسات',
                    value: _userStats['measurements']?.toString() ?? '0',
                    color: AppConstants.accentColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.description,
                    label: 'التقارير',
                    value: _userStats['reports']?.toString() ?? '0',
                    color: AppConstants.warningColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.task_alt,
                    label: 'المهام',
                    value: _userStats['tasks']?.toString() ?? '0',
                    color: AppConstants.successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: AppConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    return Card(
      child: Column(
        children: [
          _buildOptionTile(
            icon: Icons.settings,
            title: 'الإعدادات',
            subtitle: 'إعدادات التطبيق والخصوصية',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(height: 1),
          _buildOptionTile(
            icon: Icons.help_outline,
            title: 'المساعدة والدعم',
            subtitle: 'الأسئلة الشائعة والدعم الفني',
            onTap: () {
              // TODO: Navigate to help screen
            },
          ),
          const Divider(height: 1),
          _buildOptionTile(
            icon: Icons.info_outline,
            title: 'حول التطبيق',
            subtitle: 'معلومات التطبيق والإصدار',
            onTap: () {
              // TODO: Navigate to about screen
            },
          ),
          const Divider(height: 1),
          _buildOptionTile(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            subtitle: 'الخروج من الحساب الحالي',
            onTap: _logout,
            textColor: AppConstants.errorColor,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppConstants.textPrimaryColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppConstants.textPrimaryColor,
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
}
