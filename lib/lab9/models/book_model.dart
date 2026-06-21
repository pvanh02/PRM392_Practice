class Book {
  final int id;
  final String title;
  final String author;
  final String genre;
  final int year;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.year,
  });

  /// Factory to decode json representation into a Book instance
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      year: json['year'] as int? ?? 0,
    );
  }

  /// Convert Book instance to JSON dictionary
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'year': year,
    };
  }
}
