
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
  bool _disposed = false;

  Future<void> loadMoviesByGenre(String genre) async {

    if (_disposed) return;

    final currentRequestId = ++_requestId;

    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final response = await _movieRepo.getMoviesByGenre(genre);


      if (_disposed || currentRequestId != _requestId) return;

      if (response.status != 'ok' ||
          response.data?.movies == null) {
        errorMessage = response.statusMessage;
      } else {
        movies = response.data!.movies!;
      }
    } catch (e) {
      if (_disposed || currentRequestId != _requestId) return;

      errorMessage = e.toString();
    } finally {

      if (!_disposed && currentRequestId == _requestId) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;

    _requestId++;

    super.dispose();
  }
}
