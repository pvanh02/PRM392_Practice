class Contact {
  final int id;
  final String name;
  final String email;
  final String phone;

  const Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  /// Factory to decode json representation into a Contact instance
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  /// Convert Contact instance to JSON dictionary
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
