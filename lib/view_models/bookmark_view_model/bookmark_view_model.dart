import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/models/user_model.dart';
import 'package:movies_app/repos/bookmark_repo/bookmark_repo.dart';

class BookmarkViewModel extends ChangeNotifier {
  final BookmarkRepo _bookmarkRepo;

  BookmarkViewModel({required this._bookmarkRepo});

  bool isBookMarked(num? movieId) {
    if (movieId == null) return false;
    return UserModel.loggedInUser?.wishListMovies?.any(
          (item) => item['id'] == movieId,
        ) ??
        false;
  }

  bool isUpdating = false;
  String? errorMessage;


  Future<void> toggleBookmark(Movie movie) async {
    if (movie.id == null || isUpdating) return;

    isUpdating = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (isBookMarked(movie.id)) {
        await _bookmarkRepo.removeMovieFromWishList(movie);
      } else {
        await _bookmarkRepo.addMovieToWishList(movie);
      }
    } catch (e) {
      errorMessage = e.toString();
      Utilities.showToast("Failed to update bookmark");
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

}
