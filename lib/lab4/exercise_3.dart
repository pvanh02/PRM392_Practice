import 'package:flutter/material.dart';

/// Movie Model representing dynamic data for ListView.builder
class Movie {
  final String title;
  final String genre;
  final String rating;
  final String imageUrl;
  final String releaseYear;

  Movie({
    required this.title,
    required this.genre,
    required this.rating,
    required this.imageUrl,
    required this.releaseYear,
  });
}

/// Exercise 3 – Layout Basics: Column, Row, Padding, ListView
/// Implements a structured Movie Catalog screen demonstrating core layout paradigms.
class LayoutBasicsDemo extends StatelessWidget {
  LayoutBasicsDemo({super.key});

  // Sample dataset of movies
  final List<Movie> _movies = [
    Movie(
      title: 'Inception',
      genre: 'Sci-Fi / Action',
      rating: '8.8 ★',
      imageUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=200&q=80',
      releaseYear: '2010',
    ),
    Movie(
      title: 'Interstellar',
      genre: 'Sci-Fi / Adventure',
      rating: '8.7 ★',
      imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=200&q=80',
      releaseYear: '2014',
    ),
    Movie(
      title: 'The Dark Knight',
      genre: 'Action / Crime',
      rating: '9.0 ★',
      imageUrl: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=200&q=80',
      releaseYear: '2008',
    ),
    Movie(
      title: 'Avatar: The Way of Water',
      genre: 'Sci-Fi / Fantasy',
      rating: '7.6 ★',
      imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=200&q=80',
      releaseYear: '2022',
    ),
    Movie(
      title: 'Spider-Man: Into the Spider-Verse',
      genre: 'Animation / Action',
      rating: '8.4 ★',
      imageUrl: 'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=200&q=80',
      releaseYear: '2018',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3: Movie Catalog'),
        centerTitle: true,
      ),
      body: Padding(
        // Padding: Apply consistent edge spacing of 16px around the screen bounds
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Column: Align child elements starting from the left edge (cross axis)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Top Welcome Banner (Column & Row)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Cinephile 👋',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    // SizedBox: Standard spacing of 4px
                    SizedBox(height: 4),
                    Text(
                      'Explore what\'s hot today!',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 28),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.15),
                  ),
                ),
              ],
            ),
            
            // SizedBox: Standard vertical spacing of 16px
            const SizedBox(height: 16),

            // Section 2: Horizontal Row of Category Badges
            // Row is wrapped in SingleChildScrollView for horizontal scrollability
            const Text(
              'Popular Genres',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // Standard spacing of 8px
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildGenreBadge('All Movies', isSelected: true),
                  _buildGenreBadge('Action'),
                  _buildGenreBadge('Sci-Fi'),
                  _buildGenreBadge('Thriller'),
                  _buildGenreBadge('Animation'),
                ],
              ),
            ),
            
            const SizedBox(height: 16), // Standard spacing of 16px

            // Section 3: Vertical ListView.builder of Movies
            const Text(
              'Trending Movies',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12), // Standard spacing of 12px

            // Expanded: Required inside Column so ListView knows its height limits and doesn't crash (Unbounded Height Fix)
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                // itemExtent or padding can control spacing between tiles
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return Padding(
                    // Padding: Consistent vertical space of 8px between list cards
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Movie Poster Image
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Image.network(
                              movie.imageUrl,
                              width: 85,
                              height: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 85,
                                height: 110,
                                color: Colors.grey[300],
                                child: const Icon(Icons.movie, color: Colors.grey),
                              ),
                            ),
                          ),
                          // Padding & Column: Align text information neatly
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${movie.genre} • ${movie.releaseYear}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Rating score with customized design
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade100,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          movie.rating,
                                          style: TextStyle(
                                            color: Colors.amber.shade900,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      // Booking action button
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        child: const Text('Book', style: TextStyle(fontSize: 11)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper builder for Row elements (Category Badges)
  Widget _buildGenreBadge(String title, {bool isSelected = false}) {
    return Padding(
      // Padding: Apply 8px spacing on the right of each badge in the row
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.grey.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
