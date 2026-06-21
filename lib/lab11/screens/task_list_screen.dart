import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../services/task_repository.dart';
import '../services/task_provider.dart';
import 'task_tile.dart';
import 'task_detail_screen.dart';

/// Main interface for Taskly displaying all current tasks with Selector rebuild optimizations.
class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({super.key, required this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache the task icon image to prevent layout flicker
    precacheImage(const AssetImage('assets/images/task_icon.png'), context);
  }

  void _addTask() {
    final title = _controller.text.trim();
    if (title.isNotEmpty) {
      final provider = context.read<TaskProvider>();
      final nextId = provider.tasks.isEmpty
          ? 1
          : provider.tasks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
      final task = Task(id: nextId, title: title);
      provider.addTask(task);
      _controller.clear();
    }
  }

  void _toggleTask(Task task) {
    context.read<TaskProvider>().toggleTask(task);
  }

  void _deleteTask(int id) {
    context.read<TaskProvider>().deleteTask(id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.grey.shade900, Colors.black]
                  : [Colors.indigo.shade600, Colors.deepPurple.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Input row with static design elements flagged as const
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter new task...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  width: 56,
                  child: ElevatedButton(
                    key: const Key('addTaskButton'),
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),

          // ListView viewport using Selector to limit redraw triggers
          Expanded(
            child: Selector<TaskProvider, List<Task>>(
              selector: (_, provider) => provider.tasks,
              builder: (context, tasksList, child) {
                if (tasksList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display the pre-cached task icon
                        Image.asset(
                          'assets/images/task_icon.png',
                          width: 128,
                          height: 128,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.playlist_add_check_rounded,
                              size: 64,
                              color: Colors.grey.shade400,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No tasks yet. Add one!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tasksList.length,
                  itemBuilder: (context, index) {
                    final task = tasksList[index];
                    return TaskTile(
                      key: ValueKey(task.id), // Performance key configuration
                      task: task,
                      onToggle: () => _toggleTask(task),
                      onDelete: () => _deleteTask(task.id),
                      onTap: () async {
                        final changed = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                              task: task,
                              repository: widget.repository,
                            ),
                          ),
                        );
                        if (changed == true && mounted) {
                          // The detail screen might have updated the repository directly,
                          // or it has used context.read<TaskProvider>().updateTask.
                          // Call notifyListeners inside provider to ensure List updates.
                          context.read<TaskProvider>().updateTask(
                            context.read<TaskProvider>().tasks.firstWhere((t) => t.id == task.id)
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
