import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/lab11/models/task_model.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('should have default isCompleted as false', () {
      // Arrange & Act
      const task = Task(id: 1, title: 'Verify Default State');

      // Assert
      expect(task.isCompleted, isFalse);
    });

    test('toggle() should switch isCompleted state back and forth', () {
      // Arrange
      const task = Task(id: 1, title: 'Toggle Verification');

      // Act
      final toggledOnce = task.toggle();
      final toggledTwice = toggledOnce.toggle();

      // Assert
      expect(toggledOnce.isCompleted, isTrue);
      expect(toggledTwice.isCompleted, isFalse);
      expect(toggledOnce.title, equals('Toggle Verification'));
    });
  });
}
