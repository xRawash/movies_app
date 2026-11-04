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
  int _requestId = 0;


  Future<void> getMovieDetails(String movieId) async {
    final currentRequestId = ++_requestId;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final response = await _movieRepo.getMovieDetails(movieId);
      if (currentRequestId != _requestId) return;
      if (response.status != "ok" || response.data?.movie == null) {
        errorMessage = response.statusMessage;
        Utilities.showToast("Failed to load movie details");
      } else {
        movie = response.data?.movie;
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
