import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/lab11/models/task_model.dart';
import 'package:untitled/lab11/screens/task_list_screen.dart';
import 'package:untitled/lab11/services/task_repository.dart';

void main() {
  group('Taskly Navigation Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets('should navigate to TaskDetailScreen when task tile is tapped',
        (WidgetTester tester) async {
      // Arrange: Seed repository with one task
      final task = Task(id: 42, title: 'Seed Navigation Task');
      repository.addTask(task);

      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Act: Tap task item tile
      final taskTile = find.text('Seed Navigation Task');
      expect(taskTile, findsOneWidget);

      await tester.tap(taskTile);
      await tester.pumpAndSettle(); // Wait for navigation transition to settle

      // Assert: Verify detail screen headers and field keys
      expect(find.text('Task Detail'), findsOneWidget);
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
    });
  });
}
