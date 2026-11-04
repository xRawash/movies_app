import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/movies_response.dart';

import '../../api/movie_detailed_response/movie_detailed_response.dart';

class MovieRepo {
  Future<MoviesResponse> getHomeMovies() async {
    return await ApiServices.getMovieResponse();
  }
  Future<MoviesResponse> getMoviesByGenre(String genre) async {
    return await ApiServices.getMoviesByGenre(genre);
  }
  Future<MoviesResponse> getSearchResults(String query) async {
    return await ApiServices.searchMovies(query);
  }
  Future<MovieDetailedResponse> getMovieDetails(String id)async {
    return await ApiServices.getMovieDetails(id);
  }
}