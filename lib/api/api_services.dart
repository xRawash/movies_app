import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:movies_app/api/movie_detailed_response/movie_detailed_response.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/api/movie_response/movies_response.dart';
import 'package:movies_app/core/utilities/utilities.dart';

class ApiServices {
  static const String _authority = "yts.am";
  static const String _moviesEndPoint = "/api/v2/list_movies.json";
  static const String _movieDetailsEndPoint = "/api/v2/movie_details.json";
  static const String _movieSuggestions = "/api/v2/movie_suggestions.json";

  static Future<Map<String, dynamic>?> _getServerResponse(Uri url) async {
    try {
      final serverResponse = await http.get(url).timeout(const Duration(seconds: 25));
      if (serverResponse.statusCode == 200) {
        return jsonDecode(serverResponse.body) as Map<String, dynamic>;
      } else {
        Utilities.showToast("Failed to load data");
        return null;
      }
    } on SocketException {
      throw Exception("No internet connection");
    } on TimeoutException {
      throw Exception("Request timed out");
    } on FormatException {
      throw Exception("Invalid response format");
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  static Future<MoviesResponse> getMovieResponse() async {
    Uri url = Uri.https(_authority, _moviesEndPoint);
    final json = await _getServerResponse(url);
    if (json != null) {
      return MoviesResponse.fromJson(json);
    }
    return MoviesResponse(status: 'error', statusMessage: 'Failed to load movies');
  }

  static Future<MoviesResponse> getMoviesByGenre(String genre) async {
    Uri url = Uri.https(_authority, _moviesEndPoint, {'genre': genre});
    final json = await _getServerResponse(url);
    if (json != null) {
      return MoviesResponse.fromJson(json);
    }
    return MoviesResponse(status: 'error', statusMessage: 'Failed to load movies');
  }

  static Future<MoviesResponse> searchMovies(String query) async {
    Uri url = Uri.https(_authority, _moviesEndPoint, {'query_term': query});
    final json = await _getServerResponse(url);
    if (json != null) {
      return MoviesResponse.fromJson(json);
    }
    return MoviesResponse(status: 'error', statusMessage: 'Failed to search movies');
  }

  static Future<MoviesResponse> getMovieSuggestions(String movieId) async {
    Uri url = Uri.https(_authority, _movieSuggestions, {'movie_id': movieId});
    final json = await _getServerResponse(url);
    if (json != null) {
      return MoviesResponse.fromJson(json);
    }
    return MoviesResponse(status: 'error', statusMessage: 'Failed to load suggestions');
  }

  static Future<MovieDetailedResponse> getMovieDetails(String movieId) async {
    Uri url = Uri.https(_authority, _movieDetailsEndPoint, {
      'movie_id': movieId,
      'with_images': 'true',
      'with_cast': 'true',
    });
    final json = await _getServerResponse(url);
    if (json != null) {
      MovieDetailedResponse movieDetailedResponse =
          MovieDetailedResponse.fromJson(json);
      MoviesResponse moviesResponse = await getMovieSuggestions(movieId);
      if (movieDetailedResponse.data?.movie != null) {
        movieDetailedResponse.data!.movie!.similarMovies =
            moviesResponse.data?.movies ?? [];
      }
      return movieDetailedResponse;
    }
    return MovieDetailedResponse(
      status: 'error',
      statusMessage: 'Failed to load details',
    );
  }

  static Future<Movies?> getMovieById(String movieId) async {
    Uri url = Uri.https(_authority, _moviesEndPoint, {'movie_id': movieId});
    final json = await _getServerResponse(url);
    if (json != null) {
      return Movies.fromJson(json);
    }
    return null;
  }
}
