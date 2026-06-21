import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import 'task_repository.dart';

/// State management provider for Taskly wrapping [TaskRepository] with ChangeNotifier notifications
class TaskProvider extends ChangeNotifier {
  final TaskRepository repository;

  TaskProvider({required this.repository});

  /// Getter to retrieve all tasks from repository
  List<Task> get tasks => repository.tasks;

  /// Add task and notify listeners
  void addTask(Task task) {
    repository.addTask(task);
    notifyListeners();
  }

  /// Toggle task completion status and notify listeners
  void toggleTask(Task task) {
    repository.updateTask(task.toggle());
    notifyListeners();
  }

  /// Delete task by ID and notify listeners
  void deleteTask(int id) {
    repository.deleteTask(id);
    notifyListeners();
  }

  /// Update task content and notify listeners
  void updateTask(Task updatedTask) {
    repository.updateTask(updatedTask);
    notifyListeners();
  }
}
