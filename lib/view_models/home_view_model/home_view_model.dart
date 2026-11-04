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
  int _requestId = 0;


  Future<void> loadMovies() async {
    final currentRequestId = ++_requestId;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try{
      final response = await _movieRepo.getHomeMovies();
      if (currentRequestId != _requestId) return;
      if(response.status != 'ok' || response.data?.movies == null) {
        errorMessage = response.statusMessage;
        Utilities.showToast(errorMessage!);
        return;
      }
      movies = response.data!.movies!.take(15).toList();
    } catch(e) {
      if (currentRequestId != _requestId) return;
      errorMessage = e.toString();
    } finally {
      if (currentRequestId == _requestId){
        isLoading = false;
        notifyListeners();
      }

    }
  }
}