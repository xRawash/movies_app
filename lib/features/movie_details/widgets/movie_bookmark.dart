import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/core/utilities/utilities.dart';
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
          onPressed: movie.id == null || viewModel.isUpdating ? null : () async {
           await viewModel.toggleBookmark(movie);
           if (viewModel.errorMessage != null) {
             if(!context.mounted) return;
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: Text(viewModel.errorMessage!),
               ),
             );
           }
           if (viewModel.successMessage != null) {
             if(!context.mounted) return;
             Utilities.showToast(viewModel.successMessage!);
           }
          },
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_outline_sharp,
          ),
          color: Colors.white,
        );
      });
  }

}
