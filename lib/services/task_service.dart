import '../database/database_helper.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';

class TaskService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();

  // Create a new task
  Future<Task> createTask({
    required String userId,
    required String title,
    String description = '',
    TaskCategory category = TaskCategory.general,
    TaskPriority priority = TaskPriority.medium,
    DateTime? dueDate,
    DateTime? reminderDate,
  }) async {
    final now = DateTime.now();
    final task = Task(
      uuid: _uuid.v4(),
      userId: userId,
      title: title,
      description: description,
      category: category,
      priority: priority,
      status: TaskStatus.pending,
      dueDate: dueDate,
      reminderDate: reminderDate,
      createdAt: now,
      updatedAt: now,
    );

    await _dbHelper.insert('tasks', task.toMap());
    return task;
  }

  // Get task by UUID
  Future<Task?> getTaskByUuid(String uuid) async {
    final results = await _dbHelper.query(
      'tasks',
      where: 'uuid = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return Task.fromMap(results.first);
    }
    return null;
  }

  // Get all tasks for a user
  Future<List<Task>> getUserTasks(String userId) async {
    final results = await _dbHelper.query(
      'tasks',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  // Get pending tasks for a user
  Future<List<Task>> getPendingTasks(String userId) async {
    final results = await _dbHelper.query(
      'tasks',
      where: 'user_id = ? AND is_completed = 0',
      whereArgs: [userId],
      orderBy: 'due_date ASC, priority DESC, created_at ASC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  // Get completed tasks for a user
  Future<List<Task>> getCompletedTasks(String userId) async {
    final results = await _dbHelper.query(
      'tasks',
      where: 'user_id = ? AND is_completed = 1',
      whereArgs: [userId],
      orderBy: 'completed_at DESC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  // Get tasks by category
  Future<List<Task>> getTasksByCategory(String userId, String category) async {
    final results = await _dbHelper.query(
      'tasks',
      where: 'user_id = ? AND category = ?',
      whereArgs: [userId, category],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  // Get tasks by priority
  Future<List<Task>> getTasksByPriority(
    String userId,
    TaskPriority priority,
  ) async {
    final results = await _dbHelper.query(
      'tasks',
      where: 'user_id = ? AND priority = ?',
      whereArgs: [userId, priority.name],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  // Get overdue tasks
  Future<List<Task>> getOverdueTasks(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];

    final results = await _dbHelper.query(
      'tasks',
      where: 'user_id = ? AND is_completed = 0 AND due_date < ?',
      whereArgs: [userId, today],
      orderBy: 'due_date ASC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  // Get tasks due today
  Future<List<Task>> getTasksDueToday(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];

    final results = await _dbHelper.query(
      'tasks',
      where: 'user_id = ? AND is_completed = 0 AND due_date = ?',
      whereArgs: [userId, today],
      orderBy: 'priority DESC, created_at ASC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  // Get tasks with reminders
  Future<List<Task>> getTasksWithReminders(String userId) async {
    final results = await _dbHelper.query(
      'tasks',
      where: 'user_id = ? AND reminder_time IS NOT NULL AND is_completed = 0',
      whereArgs: [userId],
      orderBy: 'reminder_time ASC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  // Update task
  Future<bool> updateTask(Task task) async {
    final updatedTask = task.copyWith(updatedAt: DateTime.now());
    final result = await _dbHelper.update(
      'tasks',
      updatedTask.toMap(),
      where: 'uuid = ?',
      whereArgs: [task.uuid],
    );
    return result > 0;
  }

  // Mark task as completed
  Future<bool> completeTask(String uuid) async {
    final result = await _dbHelper.update(
      'tasks',
      {
        'is_completed': 1,
        'completed_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Mark task as incomplete
  Future<bool> uncompleteTask(String uuid) async {
    final result = await _dbHelper.update(
      'tasks',
      {
        'is_completed': 0,
        'completed_at': null,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Delete task
  Future<bool> deleteTask(String uuid) async {
    final result = await _dbHelper.delete(
      'tasks',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Search tasks
  Future<List<Task>> searchTasks(String userId, String query) async {
    final results = await _dbHelper.query(
      'tasks',
      where:
          'user_id = ? AND (title LIKE ? OR description LIKE ? OR category LIKE ?)',
      whereArgs: [userId, '%$query%', '%$query%', '%$query%'],
      orderBy: 'created_at DESC',
    );

    return results.map((map) => Task.fromMap(map)).toList();
  }

  // Get task statistics
  Future<Map<String, dynamic>> getTaskStats(String userId) async {
    final db = await _dbHelper.database;

    // Total tasks
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE user_id = ?',
      [userId],
    );

    // Completed tasks
    final completedResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND is_completed = 1',
      [userId],
    );

    // Pending tasks
    final pendingResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND is_completed = 0',
      [userId],
    );

    // Overdue tasks
    final today = DateTime.now().toIso8601String().split('T')[0];
    final overdueResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND is_completed = 0 AND due_date < ?',
      [userId, today],
    );

    // Tasks due today
    final dueTodayResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND is_completed = 0 AND due_date = ?',
      [userId, today],
    );

    // High priority tasks
    final highPriorityResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND is_completed = 0 AND priority = ?',
      [userId, 'high'],
    );

    return {
      'total': totalResult.first['count'] as int,
      'completed': completedResult.first['count'] as int,
      'pending': pendingResult.first['count'] as int,
      'overdue': overdueResult.first['count'] as int,
      'dueToday': dueTodayResult.first['count'] as int,
      'highPriority': highPriorityResult.first['count'] as int,
    };
  }

  // Get tasks grouped by category
  Future<Map<String, List<Task>>> getTasksGroupedByCategory(
    String userId,
  ) async {
    final tasks = await getUserTasks(userId);
    final Map<String, List<Task>> groupedTasks = {};

    for (final task in tasks) {
      final category = task.category.displayName;
      if (!groupedTasks.containsKey(category)) {
        groupedTasks[category] = [];
      }
      groupedTasks[category]!.add(task);
    }

    return groupedTasks;
  }

  // Get completion rate for a date range
  Future<double> getCompletionRate(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startDateString = startDate.toIso8601String().split('T')[0];
    final endDateString = endDate.toIso8601String().split('T')[0];

    final db = await _dbHelper.database;

    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND created_at >= ? AND created_at <= ?',
      [userId, startDateString, endDateString],
    );

    final completedResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE user_id = ? AND is_completed = 1 AND created_at >= ? AND created_at <= ?',
      [userId, startDateString, endDateString],
    );

    final total = totalResult.first['count'] as int;
    final completed = completedResult.first['count'] as int;

    return total > 0 ? (completed / total) * 100 : 0.0;
  }

  // Create sample tasks for testing
  Future<void> createSampleTasks(String userId) async {
    final sampleTasks = [
      {
        'title': 'تناول دواء الضغط',
        'description': 'تناول حبة واحدة من دواء الضغط صباحاً',
        'category': TaskCategory.medication,
        'priority': TaskPriority.high,
        'dueDate': DateTime.now().add(const Duration(hours: 2)),
      },
      {
        'title': 'قياس ضغط الدم',
        'description': 'قياس ضغط الدم وتسجيله في التطبيق',
        'category': TaskCategory.medical,
        'priority': TaskPriority.medium,
        'dueDate': DateTime.now().add(const Duration(days: 1)),
      },
      {
        'title': 'موعد مع الطبيب',
        'description': 'موعد مراجعة مع د. أحمد في العيادة',
        'category': TaskCategory.appointment,
        'priority': TaskPriority.high,
        'dueDate': DateTime.now().add(const Duration(days: 3)),
      },
      {
        'title': 'المشي لمدة 30 دقيقة',
        'description': 'ممارسة رياضة المشي في الحديقة',
        'category': TaskCategory.exercise,
        'priority': TaskPriority.medium,
        'dueDate': DateTime.now().add(const Duration(hours: 6)),
      },
      {
        'title': 'تحضير وجبة صحية',
        'description': 'تحضير وجبة غداء صحية قليلة الملح',
        'category': TaskCategory.diet,
        'priority': TaskPriority.low,
        'dueDate': DateTime.now().add(const Duration(hours: 4)),
      },
    ];

    for (final taskData in sampleTasks) {
      try {
        await createTask(
          userId: userId,
          title: taskData['title'] as String,
          description: taskData['description'] as String,
          category: taskData['category'] as TaskCategory,
          priority: taskData['priority'] as TaskPriority,
          dueDate: taskData['dueDate'] as DateTime?,
        );
      } catch (e) {
        print('Error creating sample task: $e');
      }
    }
  }
}
