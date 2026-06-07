/// Movie Data Model representing a single movie item for Lab 6.
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

/// Constant list of sample movies for the responsive genre screening layout.
const List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Adventure'],
    posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&q=80',
    rating: 8.8,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&q=80',
    rating: 8.7,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Crime', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=800&q=80',
    rating: 9.0,
  ),
  Movie(
    title: 'Pulp Fiction',
    year: 1994,
    genres: ['Crime', 'Drama', 'Thriller'],
    posterUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=800&q=80',
    rating: 8.9,
  ),
  Movie(
    title: 'Spirited Away',
    year: 2001,
    genres: ['Animation', 'Fantasy', 'Adventure'],
    posterUrl: 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800&q=80',
    rating: 8.6,
  ),
  Movie(
    title: 'The Godfather',
    year: 1972,
    genres: ['Crime', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1509281373149-e957c6296406?w=800&q=80',
    rating: 9.2,
  ),
];
