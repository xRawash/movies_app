import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MoviesByGenres extends StatelessWidget {
  const MoviesByGenres({super.key, required this.genreId});

  final String genreId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(genreId.toUpperCase()),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: ApiServices.getMoviesByGenre(genreId),
        builder: (context, snapshot) {
          bool isLoading = snapshot.connectionState == ConnectionState.waiting;
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error loading movies",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          List<Movies> movies = (snapshot.hasData && snapshot.data?.data?.movies != null)
              ? snapshot.data!.data!.movies!
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
    );
  }
}
