import 'package:movies_app/api/movie_response/movies_response.dart';

import '../../api/movie_detailed_response/movie_detailed_response.dart';

abstract class MovieRepo {
  Future<MoviesResponse> getHomeMovies();
  Future<MoviesResponse> getMoviesByGenre(String genre);
  Future<MoviesResponse> getSearchResults(String query);
  Future<MovieDetailedResponse> getMovieDetails(String id);
}