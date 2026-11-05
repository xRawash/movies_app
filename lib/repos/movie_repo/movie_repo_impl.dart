import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_detailed_response/movie_detailed_response.dart';
import 'package:movies_app/api/movie_response/movies_response.dart';

import 'movie_repo.dart';

class MovieRepoImpl implements MovieRepo {
  @override
  Future<MoviesResponse> getHomeMovies() async  {
    return await ApiServices.getMovieResponse();
  }
  @override
  Future<MoviesResponse> getMoviesByGenre(String genre) async {
    return await ApiServices.getMoviesByGenre(genre);
  }
  @override
  Future<MoviesResponse> getSearchResults(String query) async {
    return await ApiServices.searchMovies(query);
  }
  @override
  Future<MovieDetailedResponse> getMovieDetails(String id)async {
    return await ApiServices.getMovieDetails(id);
  }
}