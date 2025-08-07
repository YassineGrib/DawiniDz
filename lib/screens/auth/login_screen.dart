import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../services/auth_service.dart';
import '../../utils/ui_helpers.dart';
import '../home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final success = await _authService.login(email, password);

      if (success && mounted) {
        // Login successful, navigate to home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

        UIHelpers.showSuccessSnackBar(context, 'تم تسجيل الدخول بنجاح');
      } else if (mounted) {
        // Login failed
        UIHelpers.showErrorSnackBar(context, 'بيانات تسجيل الدخول غير صحيحة');
      }
    } catch (e) {
      if (mounted) {
        UIHelpers.showErrorSnackBar(
          context,
          'خطأ في تسجيل الدخول: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'تسجيل الدخول', showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.paddingXLarge),

              // Logo
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusLarge,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusLarge,
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to icon if image fails to load
                        return Container(
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge,
                            ),
                          ),
                          child: const Icon(
                            Icons.local_hospital,
                            size: 50,
                            color: AppConstants.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Welcome Text
              const Text(
                'مرحباً بك في دويني دي زد',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.paddingSmall),

              const Text(
                'سجل دخولك للوصول إلى حسابك',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.paddingXLarge),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  hintText: 'example@email.com',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'البريد الإلكتروني غير صحيح';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('تسجيل الدخول'),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Forgot Password
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ميزة استعادة كلمة المرور قيد التطوير'),
                    ),
                  );
                },
                child: const Text('نسيت كلمة المرور؟'),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Divider
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                    ),
                    child: Text(
                      'أو',
                      style: TextStyle(color: AppConstants.textSecondaryColor),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Register Button
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text('إنشاء حساب جديد'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
