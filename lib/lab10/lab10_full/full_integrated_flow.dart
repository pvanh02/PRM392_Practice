import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

/// Splash Screen for the Integrated Full App
class FullSplash extends StatefulWidget {
  const FullSplash({super.key});

  @override
  State<FullSplash> createState() => _FullSplashState();
}

class _FullSplashState extends State<FullSplash> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Show splash screen for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('full_token');
    final String? displayName = prefs.getString('full_display_name');
    final String? email = prefs.getString('full_email');
    final String? photoUrl = prefs.getString('full_photo_url');
    final String? loginType = prefs.getString('full_login_type');

    if (token != null && token.isNotEmpty) {
      // Session exists, route to Home
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FullHome(
            displayName: displayName ?? 'User',
            email: email ?? '',
            photoUrl: photoUrl ?? '',
            loginType: loginType ?? 'API',
          ),
        ),
      );
    } else {
      // Go to Login
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FullLogin(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.security_rounded,
                size: 96,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Security Shield',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PRM392 Integrated Secure Portal',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// Login Screen supporting API and Google auth
class FullLogin extends StatefulWidget {
  const FullLogin({super.key});

  @override
  State<FullLogin> createState() => _FullLoginState();
}

class _FullLoginState extends State<FullLogin> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _firebaseConfigured = false;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    // Initialize Local Notifications
    await _notificationService.init();
    await _notificationService.requestPermissions();

    // Check Firebase configuration
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      setState(() {
        _firebaseConfigured = true;
      });
    } catch (_) {
      setState(() {
        _firebaseConfigured = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveSession({
    required String token,
    required String displayName,
    required String email,
    required String photoUrl,
    required String loginType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_token', token);
    await prefs.setString('full_display_name', displayName);
    await prefs.setString('full_email', email);
    await prefs.setString('full_photo_url', photoUrl);
    await prefs.setString('full_login_type', loginType);

    // Fire successful login notification (LO7 Requirement)
    await _notificationService.showNotification(
      'Login Successful!',
      'Welcome back, $displayName! Your secure session has been restored.',
    );
  }

  Future<void> _loginWithApi() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.loginWithApi(
        _usernameController.text,
        _passwordController.text,
      );

      final displayName = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}'.trim();
      final email = user['email'] ?? '';
      final photoUrl = user['image'] ?? '';
      final token = user['token'] ?? '';

      await _saveSession(
        token: token,
        displayName: displayName.isNotEmpty ? displayName : 'API User',
        email: email,
        photoUrl: photoUrl,
        loginType: 'API',
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FullHome(
              displayName: displayName.isNotEmpty ? displayName : 'API User',
              email: email,
              photoUrl: photoUrl,
              loginType: 'API',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    if (_firebaseConfigured) {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          final UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final User? user = userCredential.user;

          if (user != null) {
            final displayName = user.displayName ?? 'Google User';
            final email = user.email ?? '';
            final photoUrl = user.photoURL ?? '';
            final token = user.uid; // Use user uid as token

            await _saveSession(
              token: token,
              displayName: displayName,
              email: email,
              photoUrl: photoUrl,
              loginType: 'Google',
            );

            if (mounted) {
              setState(() {
                _isLoading = false;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FullHome(
                    displayName: displayName,
                    email: email,
                    photoUrl: photoUrl,
                    loginType: 'Google',
                  ),
                ),
              );
            }
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorDialog(e.toString());
        }
      }
    } else {
      // Simulated Google Auth Flow fallback
      await Future.delayed(const Duration(seconds: 1));
      
      final displayName = 'Emily Johnson';
      final email = 'emily.johnson@gmail.com';
      final photoUrl = 'https://dummyjson.com/icon/emilys/128';
      final token = 'simulated_google_token_123';

      await _saveSession(
        token: token,
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
        loginType: 'Google (Simulated)',
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FullHome(
              displayName: displayName,
              email: email,
              photoUrl: photoUrl,
              loginType: 'Google (Simulated)',
            ),
          ),
        );
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 10),
            Text('Login Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrated Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.security_rounded,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Portal Sign-In',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Access your account via API credentials or Google Auth',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                // REST API credentials tip box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.secondary.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: theme.colorScheme.secondary, size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'REST API Account:\nUsername: emilys | Password: emilyspass',
                          style: TextStyle(fontSize: 12, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter username' : null,
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Please enter password' : null,
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginWithApi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text('Log In via REST API', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),

                // Divider line
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('OR', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 16),

                // Google Sign In Button
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _loginWithGoogle,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.outline),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.g_mobiledata_rounded, size: 36, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          'Sign In with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Home dashboard view showing persistent profile states
class FullHome extends StatelessWidget {
  final String displayName;
  final String email;
  final String photoUrl;
  final String loginType;

  const FullHome({
    super.key,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    this.isGoogleLogin = false,
    required this.loginType,
  });

  // Add constructor for backwards compatibility or simplified initialization
  const FullHome.withLoginType({
    super.key,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.loginType,
  }) : isGoogleLogin = false; // dummy initialization

  final bool isGoogleLogin;

  Future<void> _logout(BuildContext context) async {
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('full_token');
    await prefs.remove('full_display_name');
    await prefs.remove('full_email');
    await prefs.remove('full_photo_url');
    await prefs.remove('full_login_type');

    // Sign out from Firebase / Google
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FullLogin(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Secure Home'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Connection Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Session Verified ($loginType)',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                  child: photoUrl.isEmpty ? const Icon(Icons.person, size: 60) : null,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                displayName,
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                email,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Description card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.teal),
                          SizedBox(width: 10),
                          Text(
                            'Persistence Info',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Your auth tokens and user attributes are saved locally on disk. Re-launching this application will bypass the login credentials screen automatically until you explicitly log out.',
                        style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 48),

              ElevatedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout and Terminate Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
