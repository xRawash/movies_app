import 'package:flutter/material.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';

import '../../api/movie_detailed_response/movie.dart';

class MovieDetailViewModel extends ChangeNotifier {
  final MovieRepo _movieRepo;

  MovieDetailViewModel({required this._movieRepo});

  String? errorMessage;
  bool isLoading = false;
  Movie? movie;

  Future<void> getMovieDetails(String movieId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final response = await _movieRepo.getMovieDetails(movieId);
      if (response.status != "ok" || response.data?.movie == null) {
        errorMessage = response.statusMessage;
        Utilities.showToast("Failed to load movie details");
      } else {
        movie = response.data?.movie;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
