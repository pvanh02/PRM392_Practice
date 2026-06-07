import 'package:flutter/material.dart';

/// Lab 7 - Registration Signup Form with Validation & Premium UX
/// Demonstrates FormState, Focus nodes, password strength analytics, and async email checks.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 1. FORM KEY: Controls form state, validation triggers and resets
  final _formKey = GlobalKey<FormState>();

  // Input value tracking
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _agreeToTerms = false; // Checkbox state

  // Visual UI state flags
  bool _obscurePassword = true; // Toggle password visibility
  bool _obscureConfirmPassword = true; // Toggle confirm password visibility
  bool _isCheckingEmail = false; // Controls loading overlay / indicator during fake API checking

  // 2. FOCUS NODES: Manage focus transition and keyboard display
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  // Controllers to clear text easily
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up focus nodes and controllers when widget is destroyed
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 3. SEPARATED VALIDATORS: Maintain code clarity and testability

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    // Simple email pattern check
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // 4. PASSWORD STRENGTH ALGORITHM: Returns strength rating (0-3) and label
  int _calculatePasswordStrength(String password) {
    if (password.isEmpty) return 0;
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) score++;
    return score; // Max score 4
  }

  Color _getStrengthColor(int score) {
    if (score <= 1) return Colors.red;
    if (score == 2) return Colors.orange;
    if (score == 3) return Colors.yellow.shade700;
    return Colors.green;
  }

  String _getStrengthText(int score) {
    if (score == 0) return 'None';
    if (score <= 1) return 'Weak';
    if (score == 2) return 'Medium';
    if (score == 3) return 'Strong';
    return 'Very Strong';
  }

  // 5. ASYNC VALIDATION SUBMIT METHOD: Simulates account creation
  Future<void> _submitForm() async {
    // Close keyboard prior to validation
    FocusScope.of(context).unfocus();

    // Trigger local synchronous validation
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Ensure terms checkbox is checked
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the Terms & Conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Trigger loading spinner
    setState(() {
      _isCheckingEmail = true;
    });

    // Save local form fields state
    _formKey.currentState!.save();

    // Simulate 2-second API network delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isCheckingEmail = false;
    });

    // Fake Rule: Emails starting with "taken" are treated as already registered
    if (_email.trim().toLowerCase().startsWith('taken')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('The email "$_email" is already taken. Please try another.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // SUCCESS DIALOG: Displays success state
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('Registration Successful'),
            ],
          ),
          content: Text(
            'Welcome, $_fullName!\nYour account $_email has been created successfully.',
            style: const TextStyle(height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _formKey.currentState!.reset(); // Clear form fields
                _passwordController.clear();
                setState(() {
                  _agreeToTerms = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int pwdStrength = _calculatePasswordStrength(_password);

    // 6. GESTUREDETECTOR: Dismiss keyboard when user taps empty spaces outside inputs
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Signup'),
          centerTitle: true,
        ),
        // 7. SINGLECHILDSCROLLVIEW: Responsive layout wrapping to prevent keyboard overflow issues
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your details below to set up your new account.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  // FORM CONTAINER
                  Form(
                    key: _formKey,
                    // AUTOVALIDATE MODE: Triggers validations as the user types
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Field 1: Full Name
                        TextFormField(
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: _validateName,
                          onSaved: (value) => _fullName = value ?? '',
                          // Move focus dynamically to Email field
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_emailFocus);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Field 2: Email
                        TextFormField(
                          focusNode: _emailFocus,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            helperText: 'Emails starting with "taken" will fail async check',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: _validateEmail,
                          onSaved: (value) => _email = value ?? '',
                          // Move focus dynamically to Password field
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                        ),
                        const SizedBox(height: 16),

                        // Field 3: Password
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.next,
                          obscureText: _obscurePassword,
                          onChanged: (value) {
                            setState(() {
                              _password = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: _validatePassword,
                          // Move focus dynamically to Confirm Password field
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_confirmFocus);
                          },
                        ),
                        const SizedBox(height: 8),

                        // PASSWORD STRENGTH INDICATOR BAR (Bonus Enhancement)
                        if (_password.isNotEmpty) ...[
                          Row(
                            children: [
                              Text(
                                'Strength: ',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                              Text(
                                _getStrengthText(pwdStrength),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getStrengthColor(pwdStrength),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: List.generate(4, (index) {
                              return Expanded(
                                child: Container(
                                  height: 4,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: index < pwdStrength
                                        ? _getStrengthColor(pwdStrength)
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Field 4: Confirm Password
                        TextFormField(
                          focusNode: _confirmFocus,
                          textInputAction: TextInputAction.done,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_clock),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: _validateConfirmPassword,
                          onSaved: (value) => _confirmPassword = value ?? '',
                          // Trigger submit directly on Done IME action
                          onFieldSubmitted: (_) {
                            _submitForm();
                          },
                        ),
                        const SizedBox(height: 16),

                        // Checkbox: Terms & Conditions agreement (Bonus Enhancement)
                        Row(
                          children: [
                            Checkbox(
                              value: _agreeToTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  _agreeToTerms = value ?? false;
                                });
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'I agree to the Terms of Service & Privacy Policy',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // SUBMIT BUTTON: Shows loading indicator when performing async API validation
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isCheckingEmail ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: _isCheckingEmail
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Checking Email availability...', style: TextStyle(fontSize: 16)),
                                    ],
                                  )
                                : const Text('Register Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
