import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/features/main_layout/genres_ids/genres_ids.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';
import 'package:movies_app/view_models/genre_view_model/genre_view_model.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MoviesByGenres extends StatelessWidget {
  const MoviesByGenres({super.key, required this.genreId});

  final String genreId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(GenresIds.getLocalizedGenre(context, genreId)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => GenreViewModel(movieRepo: MovieRepo())..loadMoviesByGenre(genreId),
        child: Consumer<GenreViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.errorMessage != null && viewModel.movies.isEmpty) {
              return Center(
                child: Text(
                  "Error loading movies",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if(!viewModel.isLoading && viewModel.movies.isEmpty){
              return Center(
                child: Text(
                  "No movies found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            bool isLoading = viewModel.isLoading;
            List<Movies> movies = viewModel.movies.isNotEmpty
                ? viewModel.movies
                : List.generate(
                    10,
                    (index) => Movies(
                      title: "Loading Movie",
                      rating: 0.0,
                      year: 2024,
                      mediumCoverImage: "",
                    ),
                  );

            return Skeletonizer(
              enabled: isLoading,
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return MovieItem(movie: movies[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
