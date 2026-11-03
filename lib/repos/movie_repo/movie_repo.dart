import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/movies_response.dart';

class MovieRepo {
  Future<MoviesResponse> getHomeMovies() {
    return ApiServices.getMovieResponse();
  }
  Future<MoviesResponse> getMoviesByGenre(String genre) {
    return ApiServices.getMoviesByGenre(genre);
  }
}