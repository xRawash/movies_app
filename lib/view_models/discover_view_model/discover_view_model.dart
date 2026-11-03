import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';

class DiscoverViewModel extends ChangeNotifier {
  final MovieRepo _movieRepo;

  DiscoverViewModel({required this._movieRepo});

  List<Movies> movies = [];
  bool isLoading = false;
  String? errorMessage;

  int _requestId = 0;

  Future<void> loadMoviesByGenre(String genre) async {
    final currentRequestId = ++_requestId;

    isLoading = true;
    errorMessage = null;
    movies = [];
    notifyListeners();

    try {
      final response = await _movieRepo.getMoviesByGenre(genre);

      if (currentRequestId != _requestId) return;

      if (response.status != 'ok' || response.data?.movies == null) {
        errorMessage = response.statusMessage ?? 'Failed to load movies';
      } else {
        movies = response.data!.movies!;
      }
    } catch (e) {
      if (currentRequestId != _requestId) return;

      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      if (currentRequestId == _requestId) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _requestId++;
    super.dispose();
  }
}