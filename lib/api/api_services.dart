import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies_app/api/movie_detailed_response/Movie_detailed_response.dart';
import 'package:movies_app/api/movie_response/Movies_response.dart';

class ApiServices {
  static const String _authority = "movies-api.accel.li";
  static const String _moviesEndPoint = "/api/v2/list_movies.json";
  static const String _movieDetailsEndPoint = "/api/v2/movie_details.json";
  static const String _movieSuggestions = "/api/v2/movie_suggestions.json";

  static Future<MoviesResponse> getMovieResponse() async {
    Uri url = Uri.https(_authority, _moviesEndPoint);
    http.Response serverResponse = await http.get(url);
    Map<String, dynamic> json = jsonDecode(serverResponse.body);
    MoviesResponse movieResponse = MoviesResponse.fromJson(json);
    return movieResponse;
  }

  static Future<MoviesResponse> getMoviesByGenre(String genre) async {
    Uri url = Uri.https(_authority, _moviesEndPoint, {'genre': genre});
    http.Response serverResponse = await http.get(url);
    Map<String, dynamic> json = jsonDecode(serverResponse.body);
    MoviesResponse moviesResponseByGenre = MoviesResponse.fromJson(json);
    return moviesResponseByGenre;
  }

  static Future<MoviesResponse> searchMovies(String query) async {
    Uri url = Uri.https(_authority, _moviesEndPoint, {'query_term': query});
    http.Response serverResponse = await http.get(url);
    Map<String, dynamic> json = jsonDecode(serverResponse.body);
    MoviesResponse moviesResponse = MoviesResponse.fromJson(json);
    return moviesResponse;
  }
  static Future<MovieDetailedResponse> getMovieDetails(String movieId) async {
    Uri url = Uri.https(_authority,_movieDetailsEndPoint, {
      'movie_id': movieId,
      'with_images': 'true',
      'with_cast': 'true'
    });
    http.Response serverResponse = await http.get(url);
    Map<String, dynamic> json = jsonDecode(serverResponse.body);
    MovieDetailedResponse movieDetailedResponse = MovieDetailedResponse.fromJson(json);
    return movieDetailedResponse ;
  }
  static Future<MoviesResponse> getMovieSuggestions(String movieId) async {
    Uri url = Uri.https(_authority,_movieSuggestions, {
      'movie_id': movieId,
    });
    http.Response serverResponse = await http.get(url);
    Map<String, dynamic> json = jsonDecode(serverResponse.body);
    MoviesResponse moviesResponse = MoviesResponse.fromJson(json);
    return moviesResponse;
  }
}
