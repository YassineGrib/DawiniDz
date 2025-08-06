import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TaskService _taskService = TaskService();

  List<Task> _allTasks = [];
  List<Task> _pendingTasks = [];
  List<Task> _completedTasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Get current user ID from auth service
      const userId = 'current_user_id';
      final tasks = await _taskService.getUserTasks(userId);

      setState(() {
        _allTasks = tasks;
        _pendingTasks = tasks.where((task) => !task.isCompleted).toList();
        _completedTasks = tasks.where((task) => task.isCompleted).toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل المهام: ${e.toString()}'),
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

  Future<void> _toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(
        status: task.isCompleted ? TaskStatus.pending : TaskStatus.completed,
      );

      await _taskService.updateTask(updatedTask);
      _loadTasks();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              updatedTask.isCompleted
                  ? 'تم إنجاز المهمة'
                  : 'تم إلغاء إنجاز المهمة',
            ),
            backgroundColor: AppConstants.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحديث المهمة: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'المهام',
        showBackButton: false,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTasks),
        ],
      ),
      body: Column(
        children: [
          // Statistics Cards
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'إجمالي المهام',
                    value: '${_allTasks.length}',
                    icon: Icons.task_alt,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: _buildStatCard(
                    title: 'قيد الإنجاز',
                    value: '${_pendingTasks.length}',
                    icon: Icons.pending_actions,
                    color: AppConstants.warningColor,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: _buildStatCard(
                    title: 'مكتملة',
                    value: '${_completedTasks.length}',
                    icon: Icons.check_circle,
                    color: AppConstants.successColor,
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: AppConstants.primaryColor,
            unselectedLabelColor: AppConstants.textSecondaryColor,
            indicatorColor: AppConstants.primaryColor,
            tabs: const [
              Tab(text: 'الكل'),
              Tab(text: 'قيد الإنجاز'),
              Tab(text: 'مكتملة'),
            ],
          ),

          // Tab Views
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTasksList(_allTasks),
                      _buildTasksList(_pendingTasks),
                      _buildTasksList(_completedTasks),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingSmall),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: AppConstants.paddingSmall / 2),
            Text(
              value,
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall / 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              'لا توجد مهام',
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                color: AppConstants.textSecondaryColor,
              ),
            ),
            SizedBox(height: AppConstants.paddingSmall),
            Text(
              'اضغط على + لإضافة مهمة جديدة',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    final isOverdue =
        task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        !task.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: task),
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
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) => _toggleTaskCompletion(task),
                    activeColor: AppConstants.successColor,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? AppConstants.textSecondaryColor
                                : AppConstants.textPrimaryColor,
                          ),
                        ),
                        if (task.description?.isNotEmpty == true) ...[
                          const SizedBox(height: AppConstants.paddingSmall / 2),
                          Text(
                            task.description!,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              color: task.isCompleted
                                  ? AppConstants.textSecondaryColor
                                  : AppConstants.textSecondaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                      if (task.dueDate != null) ...[
                        const SizedBox(height: AppConstants.paddingSmall / 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingSmall,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isOverdue
                                ? AppConstants.errorColor.withValues(alpha: 0.1)
                                : AppConstants.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusSmall,
                            ),
                          ),
                          child: Text(
                            '${task.dueDate!.day}/${task.dueDate!.month}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: isOverdue
                                  ? AppConstants.errorColor
                                  : AppConstants.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingSmall),
              Row(
                children: [
                  Icon(
                    _getCategoryIcon(task.category.displayName),
                    size: 16,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall / 2),
                  Text(
                    task.category.displayName,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'طبي':
      case 'medical':
        return Icons.medical_services;
      case 'دواء':
      case 'medication':
        return Icons.medication;
      case 'موعد':
      case 'appointment':
        return Icons.calendar_today;
      case 'تمرين':
      case 'exercise':
        return Icons.fitness_center;
      case 'غذاء':
      case 'nutrition':
        return Icons.restaurant;
      default:
        return Icons.task_alt;
    }
  }
}
