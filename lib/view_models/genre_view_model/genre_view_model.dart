import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';

class GenreViewModel extends ChangeNotifier {
  final MovieRepo _movieRepo;

  GenreViewModel({required this._movieRepo});

  List<Movies> movies = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadMoviesByGenre(String genre) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final response = await _movieRepo.getMoviesByGenre(genre);
      if (response.status != 'ok' || response.data?.movies == null) {
        errorMessage = response.statusMessage;
      } else {
        movies = response.data!.movies!.take(15).toList();
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
