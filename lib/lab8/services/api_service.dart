import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

/// Service layer managing API interaction with JSONPlaceholder
class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Fetches the list of posts via GET request
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/posts'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body) as List<dynamic>;
        return decodedData.map((item) => Post.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Server error: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server. Please check your connection.');
    }
  }

  /// Submits a new post via POST request
  Future<Post> createPost(String title, String body, int userId) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/posts'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'title': title,
          'body': body,
          'userId': userId,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final Map<String, dynamic> decodedData = json.decode(response.body) as Map<String, dynamic>;
        // API mock can return JSON payload without ID or empty, we handle it or assign a fallback if needed
        return Post.fromJson(decodedData);
      } else {
        throw Exception('Server error: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to submit post. Please try again.');
    }
  }
}
