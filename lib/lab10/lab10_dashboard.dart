import 'package:flutter/material.dart';
import 'lab10_1_mock_login/mock_login_screen.dart';
import 'lab10_2_real_api_login/real_api_login_screen.dart';
import 'lab10_3_auto_login/auto_login_flow.dart';
import 'lab10_4_firebase/firebase_signin_screen.dart';
import 'lab10_5_notification/notification_demo_screen.dart';
import 'lab10_full/full_integrated_flow.dart';

/// Launcher dashboard coordinating access to all Lab 10 sub-parts
class Lab10Dashboard extends StatelessWidget {
  const Lab10Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10 Dashboard'),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner Overview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.grey.shade800, Colors.grey.shade900]
                    : [Colors.indigo.shade50, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authentication & Notification Hub',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This hub hosts exercises detailing user access controls, persistent local directories caches, OAuth, and notifications (LO7).',
                  style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Exercise 10.1 Card
          _buildItem(
            context,
            title: 'Lab 10.1: Mock Login',
            subtitle: 'Inputs verification validation, delay simulation logic.',
            icon: Icons.lock_open_rounded,
            color: Colors.blue,
            screen: const MockLoginScreen(),
          ),

          // Exercise 10.2 Card
          _buildItem(
            context,
            title: 'Lab 10.2: Real API Login',
            subtitle: 'DummyJSON POST credentials verification connection.',
            icon: Icons.cloud_done_outlined,
            color: Colors.green,
            screen: const RealApiLoginScreen(),
          ),

          // Exercise 10.3 Card
          _buildItem(
            context,
            title: 'Lab 10.3: Auto Login & Logout',
            subtitle: 'SharedPreferences session checks, SplashScreen routing.',
            icon: Icons.restore_outlined,
            color: Colors.amber.shade700,
            screen: const AutoLoginSplash(),
          ),

          // Exercise 10.4 Card
          _buildItem(
            context,
            title: 'Lab 10.4: Firebase Google Login',
            subtitle: 'Google OAuth provider credentials mapping config.',
            icon: Icons.g_mobiledata_rounded,
            color: Colors.orange,
            screen: const FirebaseSignInScreen(),
          ),

          // Exercise 10.5 Card
          _buildItem(
            context,
            title: 'Lab 10.5: Local Notifications',
            subtitle: 'Trigger instant system tray notification alerts manually.',
            icon: Icons.notifications_active_outlined,
            color: Colors.pink,
            screen: const NotificationDemoScreen(),
          ),

          // Divider before full app
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),

          // Full integrated Card
          _buildItem(
            context,
            title: 'Lab10_Full: Integrated App',
            subtitle: 'Combines real auth, Google login, auto-login splash, and LO7 notifications.',
            icon: Icons.verified_user_rounded,
            color: Colors.indigo,
            screen: const FullSplash(),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
