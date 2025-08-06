import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/medical_measurement.dart';
import '../../services/medical_measurement_service.dart';

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({super.key});

  @override
  State<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _notesController = TextEditingController();
  final MedicalMeasurementService _measurementService = MedicalMeasurementService();

  MeasurementType _selectedType = MeasurementType.bloodPressure;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _bloodSugarController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      locale: const Locale('ar', 'DZ'),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveMeasurement() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      int? systolic;
      int? diastolic;
      double? bloodSugar;

      if (_selectedType == MeasurementType.bloodPressure || _selectedType == MeasurementType.both) {
        systolic = int.tryParse(_systolicController.text);
        diastolic = int.tryParse(_diastolicController.text);
      }

      if (_selectedType == MeasurementType.bloodSugar || _selectedType == MeasurementType.both) {
        bloodSugar = double.tryParse(_bloodSugarController.text);
      }

      final timeString = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

      await _measurementService.createMeasurement(
        userId: 'current_user_id', // TODO: Get from auth service
        measurementType: _selectedType,
        systolicPressure: systolic,
        diastolicPressure: diastolic,
        bloodSugarLevel: bloodSugar,
        measurementDate: _selectedDate,
        measurementTime: timeString,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ القياس بنجاح'),
            backgroundColor: AppConstants.successColor,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حفظ القياس: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
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
      appBar: const CustomAppBar(
        title: 'إضافة قياس جديد',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Measurement Type Selection
              const Text(
                'نوع القياس',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              Row(
                children: [
                  Expanded(
                    child: _buildTypeCard(
                      type: MeasurementType.bloodPressure,
                      title: 'ضغط الدم',
                      icon: Icons.favorite,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: _buildTypeCard(
                      type: MeasurementType.bloodSugar,
                      title: 'سكر الدم',
                      icon: Icons.water_drop,
                      color: AppConstants.accentColor,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: _buildTypeCard(
                      type: MeasurementType.both,
                      title: 'كلاهما',
                      icon: Icons.monitor_heart,
                      color: AppConstants.secondaryColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.paddingLarge),
              
              // Blood Pressure Fields
              if (_selectedType == MeasurementType.bloodPressure || _selectedType == MeasurementType.both) ...[
                const Text(
                  'ضغط الدم',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _systolicController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: 'الانقباضي',
                          hintText: '120',
                          suffixText: 'mmHg',
                          prefixIcon: Icon(Icons.arrow_upward),
                        ),
                        validator: (value) {
                          if (_selectedType == MeasurementType.bloodPressure || _selectedType == MeasurementType.both) {
                            if (value == null || value.isEmpty) {
                              return 'مطلوب';
                            }
                            final intValue = int.tryParse(value);
                            if (intValue == null || intValue < 50 || intValue > 300) {
                              return 'قيمة غير صحيحة';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: TextFormField(
                        controller: _diastolicController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: 'الانبساطي',
                          hintText: '80',
                          suffixText: 'mmHg',
                          prefixIcon: Icon(Icons.arrow_downward),
                        ),
                        validator: (value) {
                          if (_selectedType == MeasurementType.bloodPressure || _selectedType == MeasurementType.both) {
                            if (value == null || value.isEmpty) {
                              return 'مطلوب';
                            }
                            final intValue = int.tryParse(value);
                            if (intValue == null || intValue < 30 || intValue > 200) {
                              return 'قيمة غير صحيحة';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.paddingLarge),
              ],
              
              // Blood Sugar Field
              if (_selectedType == MeasurementType.bloodSugar || _selectedType == MeasurementType.both) ...[
                const Text(
                  'سكر الدم',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                
                TextFormField(
                  controller: _bloodSugarController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'مستوى السكر',
                    hintText: '95.5',
                    suffixText: 'mg/dL',
                    prefixIcon: Icon(Icons.water_drop),
                  ),
                  validator: (value) {
                    if (_selectedType == MeasurementType.bloodSugar || _selectedType == MeasurementType.both) {
                      if (value == null || value.isEmpty) {
                        return 'مطلوب';
                      }
                      final doubleValue = double.tryParse(value);
                      if (doubleValue == null || doubleValue < 20 || doubleValue > 600) {
                        return 'قيمة غير صحيحة';
                      }
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppConstants.paddingLarge),
              ],
              
              // Date and Time Selection
              const Text(
                'التاريخ والوقت',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppConstants.primaryColor),
                            const SizedBox(width: AppConstants.paddingSmall),
                            Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: InkWell(
                      onTap: _selectTime,
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: AppConstants.primaryColor),
                            const SizedBox(width: AppConstants.paddingSmall),
                            Text(
                              _selectedTime.format(context),
                              style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.paddingLarge),
              
              // Notes
              const Text(
                'ملاحظات (اختياري)',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'أضف أي ملاحظات حول القياس...',
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingXLarge),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveMeasurement,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('حفظ القياس'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required MeasurementType type,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.grey[50],
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppConstants.textSecondaryColor,
              size: 32,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              title,
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppConstants.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
