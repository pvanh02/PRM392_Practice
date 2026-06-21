import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/lab11/screens/task_list_screen.dart';
import 'package:untitled/lab11/services/task_repository.dart';

void main() {
  group('Taskly End-to-End Integration Flow', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: TaskListScreen(repository: repository),
      );
    }

    testWidgets('should add, navigate, edit, save, and verify task updates in list',
        (WidgetTester tester) async {
      // 1. Pump TaskListScreen
      await tester.pumpWidget(createWidgetUnderTest());

      // 2. Add "Original title"
      final inputField = find.byKey(const Key('taskInputField'));
      final addButton = find.byKey(const Key('addTaskButton'));

      await tester.enterText(inputField, 'Original title');
      await tester.tap(addButton);
      await tester.pump();

      // Verify "Original title" is in the list
      expect(find.text('Original title'), findsOneWidget);

      // 3. Tap task to open detail screen
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      // Verify detail screen opened
      expect(find.text('Task Detail'), findsOneWidget);

      // 4. Edit title -> "Updated title"
      final detailField = find.byKey(const Key('detailTitleField'));
      expect(detailField, findsOneWidget);

      await tester.enterText(detailField, 'Updated title');

      // 5. Save changes
      final saveButton = find.byType(ElevatedButton);
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle(); // Wait for navigation transition back to settle

      // 6. Verify updated title appears in list
      expect(find.text('Original title'), findsNothing);
      expect(find.text('Updated title'), findsOneWidget);
    });
  });
}
