import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';

import '../../api/movie_response/movies.dart';

class SearchViewModel extends ChangeNotifier{
  final MovieRepo _movieRepo;
  SearchViewModel({required this._movieRepo});

  bool isLoading = false;
  String? errorMessage;
  List<Movies> movies = [];
  String query = '';

  Timer? _debounce;
  int _requestId =0;

  void searchMovies(String value) {
    query = value.trim();

    _debounce?.cancel();

    if(query.isEmpty){
      _requestId++;
      movies = [];
      isLoading = false;
      errorMessage = null;
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () => loadMovieSearchResults(query));
  }

  Future<void> loadMovieSearchResults(String searchQuery) async {
    final int currentRequestId = ++_requestId;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      final response = await _movieRepo.getSearchResults(searchQuery);

      if(currentRequestId != _requestId){
        return;
      }

      if(response.status != 'ok'){
        errorMessage = response.statusMessage ?? "Failed to search movies";
      } else {
        movies = response.data?.movies ?? [];
      }

    } catch(e){
      if(currentRequestId != _requestId) return;
      movies = [];
      errorMessage = e.toString();
    } finally {
      if(currentRequestId == _requestId) {
        isLoading = false;
        notifyListeners();
      }
    }
  }
  void clearSearch(){
    _debounce?.cancel();
    _requestId++;
    query ='';
    movies = [];
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }
  @override
  void dispose() {
    _debounce?.cancel();
    _requestId++;
    super.dispose();
  }
}