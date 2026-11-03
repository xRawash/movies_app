import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/movies_response.dart';

import '../../api/movie_detailed_response/movie_detailed_response.dart';

class MovieRepo {
  Future<MoviesResponse> getHomeMovies() {
    return ApiServices.getMovieResponse();
  }
  Future<MoviesResponse> getMoviesByGenre(String genre) {
    return ApiServices.getMoviesByGenre(genre);
  }
  Future<MoviesResponse> getSearchResults(String query) {
    return ApiServices.searchMovies(query);
  }
  Future<MovieDetailedResponse> getMovieDetails(String id) {
    return ApiServices.getMovieDetails(id);
  }
}