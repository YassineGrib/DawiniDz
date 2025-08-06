import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../../data/algeria_data.dart';
import '../../utils/ui_helpers.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  
  String? _selectedGender;
  String? _selectedWilaya;
  String? _selectedCommune;
  DateTime? _selectedDateOfBirth;
  bool _isLoading = false;

  final List<String> _genderOptions = ['ذكر', 'أنثى'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
    
    _selectedGender = widget.user.gender;
    _selectedWilaya = widget.user.wilaya;
    _selectedCommune = widget.user.commune;
    _selectedDateOfBirth = widget.user.dateOfBirth;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      locale: const Locale('ar', 'DZ'),
    );

    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedUser = widget.user.copyWith(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : null,
        address: _addressController.text.trim().isNotEmpty ? _addressController.text.trim() : null,
        gender: _selectedGender,
        wilaya: _selectedWilaya,
        commune: _selectedCommune,
        dateOfBirth: _selectedDateOfBirth,
      );

      final success = await _userService.updateUser(updatedUser);
      
      if (success && mounted) {
        UIHelpers.showSuccessSnackBar(context, 'تم تحديث الملف الشخصي بنجاح');
        Navigator.of(context).pop();
      } else if (mounted) {
        UIHelpers.showErrorSnackBar(context, 'فشل في تحديث الملف الشخصي');
      }
    } catch (e) {
      if (mounted) {
        UIHelpers.showErrorSnackBar(context, 'خطأ في تحديث الملف الشخصي: ${e.toString()}');
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
      appBar: const CustomAppBar(
        title: 'تعديل الملف الشخصي',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              _buildSectionHeader('المعلومات الشخصية'),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم الكامل',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال الاسم الكامل';
                  }
                  if (value.trim().length < 2) {
                    return 'الاسم يجب أن يكون أكثر من حرفين';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال البريد الإلكتروني';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'يرجى إدخال بريد إلكتروني صحيح';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف (اختياري)',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
                      return 'يرجى إدخال رقم هاتف صحيح';
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Date of Birth
              InkWell(
                onTap: _selectDateOfBirth,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppConstants.primaryColor),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Text(
                        _selectedDateOfBirth != null
                            ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                            : 'تاريخ الميلاد (اختياري)',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: _selectedDateOfBirth != null
                              ? AppConstants.textPrimaryColor
                              : AppConstants.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Gender
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'الجنس (اختياري)',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: _genderOptions.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              
              const SizedBox(height: AppConstants.paddingLarge),
              
              // Location Information Section
              _buildSectionHeader('معلومات الموقع'),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Wilaya
              DropdownButtonFormField<String>(
                value: _selectedWilaya,
                decoration: const InputDecoration(
                  labelText: 'الولاية (اختياري)',
                  prefixIcon: Icon(Icons.location_on),
                ),
                items: AlgeriaData.wilayas.map((wilaya) {
                  return DropdownMenuItem(
                    value: wilaya,
                    child: Text(wilaya),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWilaya = value;
                    _selectedCommune = null; // Reset commune when wilaya changes
                  });
                },
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Commune
              if (_selectedWilaya != null)
                DropdownButtonFormField<String>(
                  value: _selectedCommune,
                  decoration: const InputDecoration(
                    labelText: 'البلدية (اختياري)',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  items: AlgeriaData.getCommunesForWilaya(_selectedWilaya!).map((commune) {
                    return DropdownMenuItem(
                      value: commune,
                      child: Text(commune),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCommune = value;
                    });
                  },
                ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Address
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'العنوان (اختياري)',
                  prefixIcon: Icon(Icons.home),
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingXLarge),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('حفظ التغييرات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: AppConstants.fontSizeLarge,
        fontWeight: FontWeight.bold,
        color: AppConstants.primaryColor,
      ),
    );
  }
}
