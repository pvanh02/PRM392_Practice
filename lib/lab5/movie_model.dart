/// Model representing a Trailer associated with a Movie
class Trailer {
  final String title;      // Name of the trailer (e.g. 'Official Trailer #1')
  final String duration;   // Length of the trailer (e.g. '2m 30s')

  Trailer({
    required this.title,
    required this.duration,
  });
}

/// Model representing a Movie object containing all meta details
class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;
  final String releaseYear;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
    required this.releaseYear,
  });
}

/// Static sample dataset of movies for Lab 5 demonstration
final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Inception',
    releaseYear: '2010',
    rating: 8.8,
    posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&q=80',
    overview: 'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O., but his tragic past may doom the project.',
    genres: ['Action', 'Sci-Fi', 'Adventure', 'Thriller'],
    trailers: [
      Trailer(title: 'Official Teaser Trailer', duration: '1m 24s'),
      Trailer(title: 'Official Cinematic Trailer #1', duration: '2m 11s'),
      Trailer(title: 'Main Theatrical Trailer', duration: '2m 32s'),
    ],
  ),
  Movie(
    id: 2,
    title: 'Interstellar',
    releaseYear: '2014',
    rating: 8.7,
    posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&q=80',
    overview: 'When Earth becomes uninhabitable, a team of explorers undertakes the most important mission in human history: traveling beyond this galaxy to discover whether mankind has a future among the stars.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    trailers: [
      Trailer(title: 'First Look Teaser', duration: '1m 45s'),
      Trailer(title: 'Official Trailer #2', duration: '2m 44s'),
      Trailer(title: 'Final Hearts and Minds Trailer', duration: '2m 33s'),
    ],
  ),
  Movie(
    id: 3,
    title: 'The Dark Knight',
    releaseYear: '2008',
    rating: 9.0,
    posterUrl: 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=800&q=80',
    overview: 'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
    genres: ['Action', 'Crime', 'Drama'],
    trailers: [
      Trailer(title: 'Joker Teaser Trailer', duration: '1m 15s'),
      Trailer(title: 'Main Theatrical Trailer', duration: '2m 20s'),
    ],
  ),
  Movie(
    id: 4,
    title: 'Avatar: The Way of Water',
    releaseYear: '2022',
    rating: 7.6,
    posterUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&q=80',
    overview: 'Jake Sully lives with his newfound family formed on the extrasolar moon Pandora. Once a familiar threat returns to finish what was previously started, Jake must work with Neytiri and the army of the Na\'vi race to protect their home.',
    genres: ['Action', 'Sci-Fi', 'Fantasy', 'Adventure'],
    trailers: [
      Trailer(title: 'Official Teaser Promo', duration: '1m 38s'),
      Trailer(title: 'Official Full Length Trailer', duration: '2m 28s'),
    ],
  ),
];
