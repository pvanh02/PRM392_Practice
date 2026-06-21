import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/lab11/models/task_model.dart';
import 'package:untitled/lab11/services/task_repository.dart';

void main() {
  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('should add tasks correctly', () {
      // Arrange
      const task = Task(id: 1, title: 'Learn Flutter Testing');

      // Act
      repository.addTask(task);

      // Assert
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.first.title, equals('Learn Flutter Testing'));
    });

    test('should delete tasks correctly by ID', () {
      // Arrange
      const task1 = Task(id: 1, title: 'Task One');
      const task2 = Task(id: 2, title: 'Task Two');
      repository.addTask(task1);
      repository.addTask(task2);

      // Act
      repository.deleteTask(1);

      // Assert
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.first.id, equals(2));
    });

    test('should update task attributes correctly', () {
      // Arrange
      const task = Task(id: 1, title: 'Old Title');
      repository.addTask(task);

      // Act
      final updatedTask = task.copyWith(title: 'New Title', isCompleted: true);
      repository.updateTask(updatedTask);

      // Assert
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.first.title, equals('New Title'));
      expect(repository.tasks.first.isCompleted, isTrue);
    });
  });
}
