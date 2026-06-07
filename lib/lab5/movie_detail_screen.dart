import 'package:flutter/material.dart';
import 'movie_model.dart';

/// Lab 5 Movie Detail Screen - Renders detailed information of a selected Movie.
/// Uses extendBodyBehindAppBar to overlay a transparent AppBar on top of a Hero banner image.
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  // Favorite state toggle
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Allows the Hero banner image to go behind the AppBar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.4),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Layout: SingleChildScrollView ensures vertical responsiveness
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HERO BANNER: Stack with background poster image and a bottom gradient mask
            Stack(
              children: [
                // Image Poster Banner
                Hero(
                  tag: 'movie-poster-${movie.id}',
                  child: Image.network(
                    movie.posterUrl,
                    width: double.infinity,
                    height: 380,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 380,
                      color: Colors.grey[300],
                      child: const Icon(Icons.movie, size: 80, color: Colors.grey),
                    ),
                  ),
                ),
                
                // Dark Gradient Mask overlay at bottom of the banner
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          isDark ? Colors.black.withOpacity(0.95) : Colors.white.withOpacity(0.95),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                
                // Rating overlay badge on the top right of the poster
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.black87, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 2. MOVIE DETAILS SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Release Year
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Year: ${movie.releaseYear}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Genres wrap layout using Chips
                  Wrap(
                    spacing: 8.0, // horizontal spacing between chips
                    runSpacing: 4.0, // vertical spacing between rows
                    children: movie.genres.map((genre) {
                      return Chip(
                        label: Text(genre),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.indigo.withOpacity(0.06),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // 3. ACTION BUTTONS: Row of interactive items
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // FAVORITE TOGGLE: Updates state & triggers SnackBar feedback
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _isFavorite
                                      ? 'Added "${movie.title}" to Favorites!'
                                      : 'Removed "${movie.title}" from Favorites.',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey[600],
                          ),
                          label: Text(
                            'Favorite',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                        
                        // RATE BUTTON: Action trigger
                        TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Rating feature coming soon!')),
                            );
                          },
                          icon: Icon(Icons.star_border, color: Colors.grey[600]),
                          label: Text('Rate', style: TextStyle(color: Colors.grey[800])),
                        ),
                        
                        // SHARE BUTTON: Action trigger
                        TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sharing link for "${movie.title}"...')),
                            );
                          },
                          icon: Icon(Icons.share, color: Colors.grey[600]),
                          label: Text('Share', style: TextStyle(color: Colors.grey[800])),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. OVERVIEW PARAGRAPH: Movie summary with padding
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      height: 1.5, // adjusts line height for readability
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 5. TRAILERS SECTION: Custom ListView nested inside scroll view
                  const Text(
                    'Official Trailers & Extras',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ListView.builder: shrinkWrap & NeverScrollableScrollPhysics avoid scroll conflicts
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: movie.trailers.length,
                    itemBuilder: (context, index) {
                      final trailer = movie.trailers[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          elevation: 1,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red.shade100,
                              child: const Icon(Icons.play_arrow, color: Colors.red),
                            ),
                            title: Text(
                              trailer.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            trailing: Text(
                              trailer.duration,
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Playing: ${trailer.title}...')),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40), // Safe bottom margin
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
