import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service managing remote REST API login requests to DummyJSON
class AuthService {
  static const String loginUrl = 'https://dummyjson.com/auth/login';

  /// Authenticate credentials against DummyJSON endpoint
  Future<Map<String, dynamic>> loginWithApi(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username.trim(),
          'password': password,
          'expiresInMins': 60,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body) as Map<String, dynamic>;
        final errorMessage = errorBody['message'] ?? 'Login failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}
