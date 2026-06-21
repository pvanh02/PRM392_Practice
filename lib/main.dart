import 'package:flutter/material.dart';

// Import Lab 4 exercises
import 'lab4/exercise_1.dart';
import 'lab4/exercise_2.dart';
import 'lab4/exercise_3.dart';
import 'lab4/exercise_4.dart';
import 'lab4/exercise_5.dart';

// Import Lab 5 App
import 'lab5/movie_home_screen.dart';

// Import Lab 6 App
import 'lab6/genre_screen.dart';

// Import Lab 7 App
import 'lab7/signup_screen.dart';

// Import Lab 8 App
import 'lab8/screens/post_list_screen.dart';

// Import Lab 9 App
import 'lab9/screens/lab9_dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

/// The root application widget that manages global Dark/Light theming
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Global theme mode state
  ThemeMode _themeMode = ThemeMode.light;

  // Global theme switcher callback function
  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 UI Showcase',
      debugShowCheckedModeBanner: false,
      
      // 1. LIGHT THEME CONFIGURATION
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
          primary: Colors.indigo,
          secondary: Colors.deepPurple,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
      ),
      
      // 2. DARK THEME CONFIGURATION
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
          primary: Colors.indigoAccent,
          secondary: Colors.deepPurpleAccent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
        ),
      ),
      
      themeMode: _themeMode,
      home: Lab4Dashboard(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

/// The main dashboard screen showing options to run the 5 exercises
class Lab4Dashboard extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const Lab4Dashboard({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4: Flutter UI Fundamentals'),
        centerTitle: true,
        actions: [
          // Theme toggler directly on the dashboard
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
            onPressed: () => onThemeChanged(!isDarkMode),
            tooltip: 'Toggle Theme',
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Gradient Header Card (Premium Visual styling)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode 
                        ? [Colors.grey.shade800, const Color(0xFF0F0F0F)]
                        : [Colors.indigo.shade600, Colors.deepPurple.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(isDarkMode ? 0.05 : 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PRM392 - Flutter UI',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Explore basic widgets, layouts, inputs, app scaffolding structures, and debugging exercises.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isDarkMode ? 'Dark Mode active' : 'Light Mode active',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Title for exercises grid
              const Text(
                'Guided Exercises Showcase',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Exercise List (Card Buttons)
              _buildExerciseCard(
                context,
                title: 'Exercise 1: Core Widgets',
                subtitle: 'Text, Image.network, Icon, Card, and ListTile implementation.',
                icon: Icons.widgets_outlined,
                color: Colors.blue.shade600,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CoreWidgetsDemo()),
                  );
                },
              ),
              _buildExerciseCard(
                context,
                title: 'Exercise 2: Input Controls',
                subtitle: 'Stateful interactive widgets: Slider, Switch, Radios, and DatePicker.',
                icon: Icons.edit_note_outlined,
                color: Colors.green.shade600,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InputControlsDemo()),
                  );
                },
              ),
              _buildExerciseCard(
                context,
                title: 'Exercise 3: Layout Basics',
                subtitle: 'Composition of columns, rows, spacing, and vertical ListViews.',
                icon: Icons.grid_view_outlined,
                color: Colors.amber.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LayoutBasicsDemo()),
                  );
                },
              ),
              _buildExerciseCard(
                context,
                title: 'Exercise 4: App Structure',
                subtitle: 'Scaffolding structures (AppBars, FABs) and global theme switching.',
                icon: Icons.account_tree_outlined,
                color: Colors.purple.shade600,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppStructureDemo(
                        isDarkMode: isDarkMode,
                        onThemeChanged: onThemeChanged,
                      ),
                    ),
                  );
                },
              ),
              _buildExerciseCard(
                context,
                title: 'Exercise 5: Debug & Fix UI Errors',
                subtitle: 'Explanations and fixes for common widget constraints and context crashes.',
                icon: Icons.bug_report_outlined,
                color: Colors.red.shade600,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DebugUIErrorsDemo()),
                  );
                },
              ),
              _buildExerciseCard(
                context,
                title: 'Lab 5: Movie Detail App',
                subtitle: 'Scrollable list, Hero animations, search filter, and favorite toggle.',
                icon: Icons.movie_outlined,
                color: Colors.teal.shade600,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MovieHomeScreen()),
                  );
                },
              ),
              _buildExerciseCard(
                context,
                title: 'Lab 6: Responsive Genre Browser',
                subtitle: 'Adaptive Grid/List layouts for Mobile and Tablet viewports.',
                icon: Icons.aspect_ratio_outlined,
                color: Colors.deepOrange.shade600,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GenreScreen()),
                  );
                },
              ),
              _buildExerciseCard(
                context,
                title: 'Lab 7: Signup Form & Validation',
                subtitle: 'Signup form with focus management, strength checks, and email verification.',
                icon: Icons.app_registration_outlined,
                color: Colors.pink.shade600,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
              ),
              _buildExerciseCard(
                context,
                title: 'Lab 8: API-powered List Screen',
                subtitle: 'Retrieve posts from JSONPlaceholder API, parse JSON to model, support pull-to-refresh, search, item details, and creating new posts via POST.',
                icon: Icons.cloud_sync_outlined,
                color: Colors.teal.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PostListScreen()),
                  );
                },
              ),
              _buildExerciseCard(
                context,
                title: 'Lab 9: Local JSON Storage',
                subtitle: 'Load items from static assets and perform persistent CRUD operations on a local device contacts file.',
                icon: Icons.storage_outlined,
                color: Colors.orange.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Lab9DashboardScreen()),
                  );
                },
              ),
              
              const SizedBox(height: 30),
              
              // Course Footer info
              Center(
                child: Text(
                  'PRM392 - Summer 2026 - FPT University',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder for creating premium list cards for the exercises
  Widget _buildExerciseCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                // Colorful Icon Avatar
                CircleAvatar(
                  radius: 26,
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 18),
                
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Go to icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
