import 'package:flutter/material.dart';

/// Exercise 4 – App Structure with Scaffold, AppBar, FAB & Theme
/// Demonstrates the foundational layout structure of a screen and implements 
/// a dynamic light/dark mode system using global state callbacks.
class AppStructureDemo extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const AppStructureDemo({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 1. SCAFFOLD: The visual scaffolding for the screen
    return Scaffold(
      // 2. APPBAR: The top header bar with title and actions
      appBar: AppBar(
        title: const Text('Exercise 4: App Structure'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search clicked!')),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings clicked!')),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      
      // 3. BODY: The main content container
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header Cards
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode 
                        ? [Colors.deepPurple.shade900, Colors.indigo.shade900]
                        : [Colors.indigo.shade600, Colors.deepPurple.shade500],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to Scaffold Demo!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This screen demonstrates standard scaffolding layout structure and real-time theming updates.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Theme Settings Sub-headline
              const Text(
                'Theming Controls',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // 4. THEMEDATA INTEGRATION: Card adapting colors based on the active theme
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      // Dark Mode Switch: Toggles themeMode globally in main.dart
                      SwitchListTile(
                        value: isDarkMode,
                        onChanged: onThemeChanged,
                        title: const Text('Dark Mode'),
                        subtitle: const Text('Toggle between Light and Dark visual theme'),
                        secondary: Icon(
                          isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: isDarkMode ? Colors.amber : Colors.indigo,
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.palette),
                        title: const Text('Primary Accent Color'),
                        subtitle: Text(
                          isDarkMode ? 'Deep Purple (Dark variant)' : 'Indigo (Light variant)',
                        ),
                        trailing: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Theme Details explanation list
              const Text(
                'Structure Checklist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildChecklistItem(context, 'Scaffold holds the structural integrity', true),
              _buildChecklistItem(context, 'AppBar provides top scaffolding', true),
              _buildChecklistItem(context, 'Body holds visual widget components', true),
              _buildChecklistItem(context, 'FloatingActionButton stands at bottom right', true),
              _buildChecklistItem(context, 'ThemeData maps colors systematically', true),
            ],
          ),
        ),
      ),

      // 5. FLOATING ACTION BUTTON (FAB): Bottom action shortcut
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Triggers a quick feedback action (Snackbar)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Floating Action Button tapped!'),
              action: SnackBarAction(label: 'Undo', onPressed: () {}),
            ),
          );
        },
        tooltip: 'Quick Action',
        child: const Icon(Icons.add_alert),
      ),
    );
  }

  // Helper widget to build check items that adapt colors to theme
  Widget _buildChecklistItem(BuildContext context, String text, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle : Icons.circle_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
