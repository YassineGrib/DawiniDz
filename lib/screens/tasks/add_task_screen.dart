import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TaskService _taskService = TaskService();

  String _selectedCategory = '';
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedReminderTime;
  bool _isLoading = false;

  final List<String> _categories = [
    'طبي',
    'دواء',
    'موعد',
    'تمرين',
    'غذاء',
    'عام',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ar', 'DZ'),
    );

    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedReminderTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedReminderTime) {
      setState(() {
        _selectedReminderTime = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      DateTime? reminderDateTime;
      if (_selectedDueDate != null && _selectedReminderTime != null) {
        reminderDateTime = DateTime(
          _selectedDueDate!.year,
          _selectedDueDate!.month,
          _selectedDueDate!.day,
          _selectedReminderTime!.hour,
          _selectedReminderTime!.minute,
        );
      }

      await _taskService.createTask(
        userId: 'current_user_id', // TODO: Get from auth service
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: TaskCategory.values.firstWhere(
          (e) => e.displayName == _selectedCategory,
          orElse: () => TaskCategory.general,
        ),
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
        reminderDate: reminderDateTime,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء المهمة بنجاح'),
            backgroundColor: AppConstants.successColor,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إنشاء المهمة: ${e.toString()}'),
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
      appBar: const CustomAppBar(title: 'إضافة مهمة جديدة'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'عنوان المهمة',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'أدخل عنوان المهمة...',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى إدخال عنوان المهمة';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Description
              const Text(
                'الوصف (اختياري)',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'أدخل وصف المهمة...',
                  prefixIcon: Icon(Icons.description),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Category
              const Text(
                'الفئة',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              DropdownButtonFormField<String>(
                value: _selectedCategory.isEmpty ? null : _selectedCategory,
                decoration: const InputDecoration(
                  hintText: 'اختر فئة المهمة',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? '';
                  });
                },
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Priority
              const Text(
                'الأولوية',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              Row(
                children: [
                  Expanded(
                    child: _buildPriorityCard(
                      priority: TaskPriority.low,
                      title: 'منخفضة',
                      color: AppConstants.successColor,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: _buildPriorityCard(
                      priority: TaskPriority.medium,
                      title: 'متوسطة',
                      color: AppConstants.warningColor,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: _buildPriorityCard(
                      priority: TaskPriority.high,
                      title: 'عالية',
                      color: AppConstants.errorColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Due Date
              const Text(
                'تاريخ الاستحقاق (اختياري)',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),

              InkWell(
                onTap: _selectDueDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppConstants.primaryColor,
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Text(
                        _selectedDueDate != null
                            ? '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'
                            : 'اختر تاريخ الاستحقاق',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: _selectedDueDate != null
                              ? AppConstants.textPrimaryColor
                              : AppConstants.textSecondaryColor,
                        ),
                      ),
                      const Spacer(),
                      if (_selectedDueDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _selectedDueDate = null;
                              _selectedReminderTime = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Reminder Time
              if (_selectedDueDate != null) ...[
                const SizedBox(height: AppConstants.paddingLarge),

                const Text(
                  'وقت التذكير (اختياري)',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),

                InkWell(
                  onTap: _selectReminderTime,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: AppConstants.primaryColor,
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Text(
                          _selectedReminderTime != null
                              ? _selectedReminderTime!.format(context)
                              : 'اختر وقت التذكير',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            color: _selectedReminderTime != null
                                ? AppConstants.textPrimaryColor
                                : AppConstants.textSecondaryColor,
                          ),
                        ),
                        const Spacer(),
                        if (_selectedReminderTime != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _selectedReminderTime = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppConstants.paddingXLarge),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveTask,
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
                      : const Text('إنشاء المهمة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityCard({
    required TaskPriority priority,
    required String title,
    required Color color,
  }) {
    final isSelected = _selectedPriority == priority;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
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
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? color : AppConstants.textSecondaryColor,
                shape: BoxShape.circle,
              ),
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
