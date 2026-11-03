import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';

class HomeViewModel extends ChangeNotifier {
  final MovieRepo _movieRepo;

  HomeViewModel({required this._movieRepo});
  List<Movies> movies = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadMovies() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try{
      final response = await _movieRepo.getHomeMovies();

      if(response.status != 'ok' || response.data?.movies == null) {
        Utilities.showToast(response.statusMessage ?? "Failed to load movies");
        return;
      }
      movies = response.data!.movies!.take(15).toList();
    } catch(e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}