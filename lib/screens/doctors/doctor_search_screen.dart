import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/doctor.dart';
import '../../services/doctor_service.dart';
import 'doctor_detail_screen.dart';

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DoctorService _doctorService = DoctorService();

  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = false;
  String? _selectedSpecialty;
  String? _selectedWilaya;
  List<String> _specialties = [];
  List<String> _wilayas = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final doctors = await _doctorService.getAvailableDoctors();
      final specialties = await _doctorService.getSpecialties();
      final wilayas = await _doctorService.getWilayas();

      setState(() {
        _doctors = doctors;
        _filteredDoctors = doctors;
        _specialties = specialties;
        _wilayas = wilayas;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل البيانات: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchDoctors() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _doctorService.searchDoctors(
        name: _searchController.text.isNotEmpty ? _searchController.text : null,
        specialty: _selectedSpecialty,
        wilaya: _selectedWilaya,
      );

      setState(() {
        _filteredDoctors = results;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في البحث: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedSpecialty = null;
      _selectedWilaya = null;
      _filteredDoctors = _doctors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'البحث عن طبيب'),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'ابحث بالاسم...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _searchDoctors();
                    }
                  },
                  onSubmitted: (value) => _searchDoctors(),
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                // Filter Row
                Row(
                  children: [
                    // Specialty Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSpecialty,
                        decoration: const InputDecoration(
                          labelText: 'التخصص',
                          prefixIcon: Icon(Icons.medical_services),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text(
                              'جميع التخصصات',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ..._specialties.map(
                            (specialty) => DropdownMenuItem(
                              value: specialty,
                              child: Text(
                                specialty,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedSpecialty = value;
                          });
                          _searchDoctors();
                        },
                      ),
                    ),

                    const SizedBox(width: AppConstants.paddingSmall),

                    // Wilaya Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedWilaya,
                        decoration: const InputDecoration(
                          labelText: 'الولاية',
                          prefixIcon: Icon(Icons.location_on),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text(
                              'جميع الولايات',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ..._wilayas.map(
                            (wilaya) => DropdownMenuItem(
                              value: wilaya,
                              child: Text(
                                wilaya,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedWilaya = value;
                          });
                          _searchDoctors();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.paddingMedium),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _searchDoctors,
                        icon: const Icon(Icons.search),
                        label: const Text('بحث'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear),
                        label: const Text('مسح الفلاتر'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredDoctors.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppConstants.textSecondaryColor,
                        ),
                        SizedBox(height: AppConstants.paddingMedium),
                        Text(
                          'لم يتم العثور على أطباء',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                        SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          'جرب تغيير معايير البحث',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _filteredDoctors[index];
                      return _buildDoctorCard(doctor);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DoctorDetailScreen(doctor: doctor),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppConstants.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    child: Text(
                      doctor.fullName.split(' ').first.substring(0, 1),
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeXLarge,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.fullName,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall / 2),
                        Text(
                          doctor.specialty,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            doctor.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingSmall / 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingSmall,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: doctor.isAvailable
                              ? AppConstants.successColor.withValues(alpha: 0.1)
                              : AppConstants.errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusSmall,
                          ),
                        ),
                        child: Text(
                          doctor.isAvailable ? 'متاح' : 'غير متاح',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: doctor.isAvailable
                                ? AppConstants.successColor
                                : AppConstants.errorColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall / 2),
                  Expanded(
                    child: Text(
                      '${doctor.wilaya} - ${doctor.commune}',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                  ),
                  if (doctor.consultationFee != null) ...[
                    const Icon(
                      Icons.payments,
                      size: 16,
                      color: AppConstants.textSecondaryColor,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall / 2),
                    Text(
                      '${doctor.consultationFee!.toStringAsFixed(0)} دج',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),

              if (doctor.yearsExperience != null) ...[
                const SizedBox(height: AppConstants.paddingSmall / 2),
                Row(
                  children: [
                    const Icon(
                      Icons.work,
                      size: 16,
                      color: AppConstants.textSecondaryColor,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall / 2),
                    Text(
                      '${doctor.yearsExperience} سنة خبرة',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
