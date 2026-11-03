import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';

class GenreViewModel extends ChangeNotifier {
  final MovieRepo _movieRepo;

  GenreViewModel({required this._movieRepo});

  List<Movies> movies = [];
  bool isLoading = false;
  String? errorMessage;
  int _requestId = 0;

  Future<void> loadMoviesByGenre(String genre) async {
    final currentRequestId = ++_requestId;
    if (currentRequestId != _requestId) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final response = await _movieRepo.getMoviesByGenre(genre);
      if (currentRequestId != _requestId) return;
      if (response.status != 'ok' || response.data?.movies == null) {
        errorMessage = response.statusMessage;
      } else {
        movies = response.data!.movies!;
      }
    } catch (e) {
      if (currentRequestId != _requestId) return;
      errorMessage = e.toString();
    } finally {
      if (currentRequestId == _requestId) {
        isLoading = false;
        notifyListeners();
      }
    }
  }
}
