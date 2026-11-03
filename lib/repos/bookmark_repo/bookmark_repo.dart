import 'package:movies_app/firebase/firebase_services.dart';

import '../../api/movie_detailed_response/movie.dart';

class BookmarkRepo {
  Future<void> addMovieToWishList(Movie movie) async{
    return FirebaseServices.addMovieToWishList(movie);
  }
  Future<void> removeMovieFromWishList(Movie movie) async{
    return FirebaseServices.removeMovieFromWishList(movie);
  }
}