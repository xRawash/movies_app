import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/repos/bookmark_repo/bookmark_repo.dart';

class BookmarkRepoImpl implements BookmarkRepo {
  @override
  Future<void> addMovieToWishList(Movie movie) async{
    return FirebaseServices.addMovieToWishList(movie);
  }
  @override
  Future<void> removeMovieFromWishList(Movie movie) async{
    return FirebaseServices.removeMovieFromWishList(movie);
  }
}