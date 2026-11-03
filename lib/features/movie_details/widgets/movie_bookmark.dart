import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/models/user_model.dart';
import 'package:movies_app/view_models/bookmark_view_model/bookmark_view_model.dart';
import 'package:provider/provider.dart';

class MovieBookmark extends StatelessWidget {
  const MovieBookmark({super.key, required this.movie});
  final Movie movie;
  @override
  Widget build(BuildContext context) {

    return Consumer<BookmarkViewModel>(
      builder: (context, viewModel, child) {
        bool isBookmarked = viewModel.isBookMarked(movie.id);
        return IconButton(
          onPressed: movie.id == null || viewModel.isUpdating ? null : ()=> viewModel.toggleBookmark(movie) ,
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_outline_sharp,
          ),
          color: Colors.white,
        );
      });
  }

}
