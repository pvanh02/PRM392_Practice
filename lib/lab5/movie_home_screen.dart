import 'package:flutter/material.dart';
import 'movie_model.dart';
import 'movie_detail_screen.dart';

/// Lab 5 Home Screen - Displays a scrollable list of movies
/// Includes an interactive search bar to dynamically filter the movies by title.
class MovieHomeScreen extends StatefulWidget {
  const MovieHomeScreen({super.key});

  @override
  State<MovieHomeScreen> createState() => _MovieHomeScreenState();
}

class _MovieHomeScreenState extends State<MovieHomeScreen> {
  // Search text query state
  String _searchQuery = '';
  
  // List of filtered movies based on query
  List<Movie> get _filteredMovies {
    if (_searchQuery.isEmpty) {
      return sampleMovies;
    }
    return sampleMovies
        .where((movie) => movie.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blockbuster Movies'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. SEARCH BAR CONTAINER: Search input field to filter movies
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: TextField(
              onChanged: (value) {
                // Update query state to trigger re-build filtering
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. LIST VIEW: Renders either the filtered movie list or a search feedback banner
          Expanded(
            child: _filteredMovies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie_creation_outlined, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text(
                          'No movies found!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Try searching for another keyword',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = _filteredMovies[index];
                      
                      // 3. MOVIE CARD: Visual representation of a single movie item
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: InkWell(
                            // NAVIGATION ON TAP: Passes movie object to Detail screen
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(movie: movie),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Row(
                              children: [
                                // Poster Thumbnail (Left)
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    bottomLeft: Radius.circular(14),
                                  ),
                                  child: Image.network(
                                    movie.posterUrl,
                                    width: 100,
                                    height: 135,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 100,
                                      height: 135,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.movie, color: Colors.grey, size: 36),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Movie Details Text info (Right)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${movie.releaseYear} • ${movie.genres.take(2).join(', ')}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        
                                        // Star rating row
                                        Row(
                                          children: [
                                            const Icon(Icons.star, color: Colors.amber, size: 20),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${movie.rating} / 10',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Forward indicator icon
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
