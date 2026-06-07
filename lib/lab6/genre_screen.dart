import 'package:flutter/material.dart';
import 'movie_model.dart';
import 'movie_card.dart';

/// Lab 6 main screen - A highly responsive movie browsing and filtering screen.
/// Adapts layout dynamically based on constraints:
/// - Screen width < 800px: ListView (1 column)
/// - Screen width >= 800px: GridView (2 columns)
class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // State variables for filtering & sorting
  String _searchQuery = '';
  final Set<String> _selectedGenres = {};
  String _selectedSort = 'A-Z'; // Default sort options: A-Z, Z-A, Year, Rating

  // Available unique genres gathered from sample movies data
  final List<String> _availableGenres = [
    'Action',
    'Sci-Fi',
    'Adventure',
    'Crime',
    'Drama',
    'Thriller',
    'Animation',
    'Fantasy',
  ];

  // Helper function to clear all search, genre selections, and sorting
  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedGenres.clear();
      _selectedSort = 'A-Z';
    });
  }

  // Logic: Filter and sort movies dynamically in the build method
  List<Movie> get _processedMovies {
    // 1. Filtering by search query & selected genres
    List<Movie> filtered = allMovies.where((movie) {
      // Filter by search text (case-insensitive)
      final bool matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter by genres (if any are selected, movie must contain at least one of them)
      final bool matchesGenre = _selectedGenres.isEmpty ||
          movie.genres.any((genre) => _selectedGenres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList();

    // 2. Sorting based on dropdown selection
    switch (_selectedSort) {
      case 'A-Z':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        // Sort by year descending (newest first)
        filtered.sort((a, b) => b.year.compareTo(a.year));
        break;
      case 'Rating':
        // Sort by rating descending (highest first)
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // SAFE AREA: Protects layout against screen notches and camera cutouts
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row (App Title + Clear Filter Button)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Find a Movie',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  // Clear Filters Action Button (Bonus Enhancement)
                  if (_searchQuery.isNotEmpty || _selectedGenres.isNotEmpty || _selectedSort != 'A-Z')
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.filter_alt_off, size: 16),
                      label: const Text('Clear Filters', style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // Responsive Search Bar & Sort Dropdown Row
              // If screen is narrow, display vertically, otherwise arrange side-by-side
              screenWidth < 600
                  ? Column(
                      children: [
                        _buildSearchBar(isDark),
                        const SizedBox(height: 12),
                        _buildSortDropdown(isDark),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildSearchBar(isDark)),
                        const SizedBox(width: 16),
                        _buildSortDropdown(isDark),
                      ],
                    ),
              const SizedBox(height: 18),

              // Genres Wrap Section with badge counts (Bonus Enhancement)
              Row(
                children: [
                  const Text(
                    'Filter by Genre',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  // Active filter badge count (Bonus)
                  if (_selectedGenres.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_selectedGenres.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              
              // WRAP: Automatically wraps genre chips to a new line responsively
              Wrap(
                spacing: 8.0, // Horizontal space between chips
                runSpacing: 4.0, // Vertical space between rows
                children: _availableGenres.map((genre) {
                  final bool isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                    selectedColor: Colors.indigo.shade200,
                    checkmarkColor: Colors.indigo.shade900,
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: isSelected 
                          ? Colors.indigo.shade900 
                          : (isDark ? Colors.white : Colors.black87),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),

              // List of movies title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results (${_processedMovies.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 3. RESPONSIVE MOVIE LIST AREA: Uses LayoutBuilder to determine columns
              Expanded(
                child: _processedMovies.isEmpty
                    ? _buildNoResultsView()
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final double maxWidth = constraints.maxWidth;

                          // BREAKPOINT: 800px dictates Layout structure
                          if (maxWidth < 800) {
                            // Phone View: Single-column ListView
                            return ListView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: _processedMovies.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: MovieCard(movie: _processedMovies[index]),
                                );
                              },
                            );
                          } else {
                            // Tablet/Web View: Multi-column GridView (2 columns)
                            return GridView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 16.0,
                                childAspectRatio: 2.1, // ratio optimized to display responsive horizontal cards
                              ),
                              itemCount: _processedMovies.length,
                              itemBuilder: (context, index) {
                                return MovieCard(movie: _processedMovies[index]);
                              },
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper builder: Search Text Field
  Widget _buildSearchBar(bool isDark) {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search title...',
        prefixIcon: const Icon(Icons.search, color: Colors.indigo),
        filled: true,
        fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Helper builder: Sort Dropdown Menu
  Widget _buildSortDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSort,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSort = newValue;
              });
            }
          },
          icon: const Icon(Icons.sort, color: Colors.indigo),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          items: const [
            DropdownMenuItem(value: 'A-Z', child: Text('Sort: A–Z')),
            DropdownMenuItem(value: 'Z-A', child: Text('Sort: Z–A')),
            DropdownMenuItem(value: 'Year', child: Text('Sort: Year')),
            DropdownMenuItem(value: 'Rating', child: Text('Sort: Rating')),
          ],
        ),
      ),
    );
  }

  // Helper builder: Empty feedback banner when filters yield 0 results
  Widget _buildNoResultsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 65, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            'No matching movies found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your search criteria or tags.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearFilters,
            child: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }
}
