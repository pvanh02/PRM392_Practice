import '../models/task_model.dart';

/// Repository coordinating operations on Task instances in-memory
class TaskRepository {
  final List<Task> _tasks = [];

  /// Return an unmodifiable view of all tasks
  List<Task> get tasks => List.unmodifiable(_tasks);

  /// Add a task to the collection
  void addTask(Task task) {
    _tasks.add(task);
  }

  /// Delete a task by matching id
  void deleteTask(int id) {
    _tasks.removeWhere((t) => t.id == id);
  }

  /// Update an existing task matching by id
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  /// Clear all tasks inside repository
  void clear() {
    _tasks.clear();
  }
}
