import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/Movie.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/models/user_model.dart';

class MovieBookmark extends StatefulWidget {
  const MovieBookmark({super.key, required this.movie});
  final Movie movie;

  @override
  State<MovieBookmark> createState() => _MovieBookmarkState();
}

class _MovieBookmarkState extends State<MovieBookmark> {

  @override
  Widget build(BuildContext context) {
    bool isBookMarked =
        UserModel.loggedInUser?.wishListMovies?.any(
              (item) => item['id'] == widget.movie.id,
        ) ??
            false;
    return IconButton(
      onPressed: () async {
        setState(() {
          if (isBookMarked) {
            FirebaseServices.removeMovieFromWishList(widget.movie);
          } else {
            FirebaseServices.addMovieToWishList(widget.movie);
          }
        });
      },
      icon: Icon(
        isBookMarked ? Icons.bookmark : Icons.bookmark_outline_sharp,
      ),
      color: Colors.white,
    );
  }
}
