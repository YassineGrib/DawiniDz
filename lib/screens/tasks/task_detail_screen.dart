import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'تفاصيل المهمة'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(
                            AppConstants.paddingMedium,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(
                              task.priority,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge,
                            ),
                          ),
                          child: Icon(
                            task.isCompleted
                                ? Icons.check_circle
                                : Icons.task_alt,
                            color: task.isCompleted
                                ? AppConstants.successColor
                                : _getPriorityColor(task.priority),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeXLarge,
                                  fontWeight: FontWeight.bold,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isCompleted
                                      ? AppConstants.textSecondaryColor
                                      : AppConstants.textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: AppConstants.paddingSmall),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.paddingSmall,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(
                                    task.priority,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadiusSmall,
                                  ),
                                ),
                                child: Text(
                                  _getPriorityText(task.priority),
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeSmall,
                                    color: _getPriorityColor(task.priority),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (task.description?.isNotEmpty == true) ...[
                      const SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        task.description!,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: task.isCompleted
                              ? AppConstants.textSecondaryColor
                              : AppConstants.textPrimaryColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingMedium),

            // Task Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'تفاصيل المهمة',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),

                    _buildDetailRow(
                      icon: Icons.category,
                      label: 'الفئة',
                      value: task.category.displayName,
                    ),

                    _buildDetailRow(
                      icon: Icons.flag,
                      label: 'الأولوية',
                      value: _getPriorityText(task.priority),
                      valueColor: _getPriorityColor(task.priority),
                    ),

                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: 'تاريخ الإنشاء',
                      value:
                          '${task.createdAt.day}/${task.createdAt.month}/${task.createdAt.year}',
                    ),

                    if (task.dueDate != null)
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: 'تاريخ الاستحقاق',
                        value:
                            '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                        valueColor:
                            task.dueDate!.isBefore(DateTime.now()) &&
                                !task.isCompleted
                            ? AppConstants.errorColor
                            : null,
                      ),

                    if (task.reminderTime != null)
                      _buildDetailRow(
                        icon: Icons.notifications,
                        label: 'وقت التذكير',
                        value:
                            '${task.reminderTime!.hour.toString().padLeft(2, '0')}:${task.reminderTime!.minute.toString().padLeft(2, '0')}',
                      ),

                    _buildDetailRow(
                      icon: task.isCompleted
                          ? Icons.check_circle
                          : Icons.pending,
                      label: 'الحالة',
                      value: task.isCompleted ? 'مكتملة' : 'قيد الإنجاز',
                      valueColor: task.isCompleted
                          ? AppConstants.successColor
                          : AppConstants.warningColor,
                    ),

                    if (task.isCompleted && task.completedAt != null)
                      _buildDetailRow(
                        icon: Icons.done,
                        label: 'تاريخ الإنجاز',
                        value:
                            '${task.completedAt!.day}/${task.completedAt!.month}/${task.completedAt!.year}',
                        valueColor: AppConstants.successColor,
                      ),
                  ],
                ),
              ),
            ),

            // Status Card
            if (task.dueDate != null && !task.isCompleted) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              Card(
                color: task.dueDate!.isBefore(DateTime.now())
                    ? AppConstants.errorColor.withValues(alpha: 0.1)
                    : AppConstants.warningColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Row(
                    children: [
                      Icon(
                        task.dueDate!.isBefore(DateTime.now())
                            ? Icons.warning
                            : Icons.schedule,
                        color: task.dueDate!.isBefore(DateTime.now())
                            ? AppConstants.errorColor
                            : AppConstants.warningColor,
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Text(
                          task.dueDate!.isBefore(DateTime.now())
                              ? 'هذه المهمة متأخرة!'
                              : 'هذه المهمة لها موعد استحقاق',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                            color: task.dueDate!.isBefore(DateTime.now())
                                ? AppConstants.errorColor
                                : AppConstants.warningColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppConstants.textSecondaryColor),
          const SizedBox(width: AppConstants.paddingMedium),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: valueColor ?? AppConstants.textSecondaryColor,
                fontWeight: valueColor != null
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppConstants.successColor;
      case TaskPriority.medium:
        return AppConstants.warningColor;
      case TaskPriority.high:
        return AppConstants.errorColor;
      case TaskPriority.urgent:
        return Colors.red.shade700;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'منخفضة';
      case TaskPriority.medium:
        return 'متوسطة';
      case TaskPriority.high:
        return 'عالية';
      case TaskPriority.urgent:
        return 'عاجلة';
    }
  }
}
