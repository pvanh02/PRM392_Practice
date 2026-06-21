/// Task model representing individual tasks in the Taskly application
class Task {
  final int id;
  final String title;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  /// Inverts task completion status and returns a new instance
  Task toggle() {
    return Task(
      id: id,
      title: title,
      isCompleted: !isCompleted,
    );
  }

  /// Copy properties with overrides into a new task instance
  Task copyWith({
    int? id,
    String? title,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
