import '../../api/movie_detailed_response/movie.dart';

abstract class BookmarkRepo {
  Future<void> addMovieToWishList(Movie movie);
  Future<void> removeMovieFromWishList(Movie movie);
}