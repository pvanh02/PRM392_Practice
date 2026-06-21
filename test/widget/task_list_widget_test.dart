import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/lab11/screens/task_list_screen.dart';
import 'package:untitled/lab11/services/task_repository.dart';

void main() {
  group('TaskListScreen Widget Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: TaskListScreen(repository: repository),
      );
    }

    testWidgets('should render empty state message when there are no tasks',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('should add and display task on tapping add button',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      final inputField = find.byKey(const Key('taskInputField'));
      final addButton = find.byKey(const Key('addTaskButton'));

      await tester.enterText(inputField, 'New Test Task');
      await tester.tap(addButton);
      await tester.pump(); // Trigger layout rebuild

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsNothing);
      expect(find.text('New Test Task'), findsOneWidget);
    });

    testWidgets('should display multiple tasks correctly',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      final inputField = find.byKey(const Key('taskInputField'));
      final addButton = find.byKey(const Key('addTaskButton'));

      await tester.enterText(inputField, 'Task Alpha');
      await tester.tap(addButton);
      await tester.pump();

      await tester.enterText(inputField, 'Task Beta');
      await tester.tap(addButton);
      await tester.pump();

      // Assert
      expect(find.text('Task Alpha'), findsOneWidget);
      expect(find.text('Task Beta'), findsOneWidget);
    });
  });
}
