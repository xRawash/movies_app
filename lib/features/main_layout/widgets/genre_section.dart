import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/Movies.dart';
import 'package:movies_app/api/movie_response/Movies_response.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/features/main_layout/movie_item/movie_item.dart';

class GenreSection extends StatefulWidget {
  const GenreSection({super.key, required this.genre});
  final String genre;

  @override
  State<GenreSection> createState() => _GenreSectionState();
}

class _GenreSectionState extends State<GenreSection> {
  late Future<MoviesResponse> genreFuture;

  @override
  void initState() {
    super.initState();
    genreFuture = ApiServices.getMoviesByGenre(widget.genre);
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.genre[0].toUpperCase() + widget.genre.substring(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "See More  →",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: ColorsManager.yellow,
                        fontSize: 14,
                      ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: FutureBuilder<MoviesResponse>(
            future: genreFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: ColorsManager.yellow),
                );
              }
              if (snapshot.hasError ||
                  snapshot.data?.data == null ||
                  snapshot.data!.data!.movies == null ||
                  snapshot.data!.data!.movies!.isEmpty) {
                return Center(
                  child: Text(
                    "No movies found",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }
              List<Movies> movies = snapshot.data!.data!.movies!.take(15).toList();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Container(
                    width: 140,
                    margin: EdgeInsets.only(right: 12),
                    child: MovieItem(movie: movies[index]),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
