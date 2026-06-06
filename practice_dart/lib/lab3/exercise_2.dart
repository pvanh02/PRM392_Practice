import 'dart:convert';

// ============================================================================
// EXERCISE 2: User Repository with JSON
// Goal: Practice JSON serialization / deserialization.
// ============================================================================

/// 1. Create User model with properties { name, email } and a factory constructor
class Lab3User {
  final String name;
  final String email;

  Lab3User({required this.name, required this.email});

  /// Factory constructor to deserialize a Map (JSON) into a User instance
  factory Lab3User.fromJson(Map<String, dynamic> json) {
    return Lab3User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() {
    return 'User(Name: "$name", Email: <$email>)';
  }
}

/// UserRepository to fetch and decode simulated JSON list API payload
class UserRepository {
  // 2. Simulate JSON list response from an API
  static const String _mockApiResponse = '''
  [
    {"name": "Alice Pham", "email": "alice.pham@fpt.edu.vn"},
    {"name": "Bob Nguyen", "email": "bob.nguyen@fpt.edu.vn"},
    {"name": "Charlie Le", "email": "charlie.le@fpt.edu.vn"}
  ]
  ''';

  // 3. Use Future<List<Lab3User>> to simulate fetching and parsing
  Future<List<Lab3User>> fetchUsers() async {
    // Simulating 1-second network latency
    await Future.delayed(const Duration(seconds: 1));

    // Deserialization logic:
    // a. Decode the raw JSON string into a Dart List of Maps
    final decodedData = jsonDecode(_mockApiResponse) as List<dynamic>;

    // b. Map each JSON object to a User instance using User.fromJson()
    return decodedData
        .map((item) => Lab3User.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

/// Runner for Exercise 2
Future<void> runExercise2() async {
  print('======================================================================');
  print('EXERCISE 2: User Repository with JSON');
  print('======================================================================');

  final userRepo = UserRepository();
  print('[API] Querying mock endpoint for user data...');

  try {
    // Fetch and parse asynchronously
    final users = await userRepo.fetchUsers();

    // 4. Display results using print()
    print('[API] Deserialization successful! Received ${users.length} users:');
    for (int i = 0; i < users.length; i++) {
      print('  [User #${i + 1}] ${users[i]}');
    }
  } catch (e) {
    print('[Error] Failed to fetch or parse users: $e');
  }

  print('======================================================================\n');
}
