import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_detailed_response/Movie.dart';
import 'package:movies_app/api/movie_detailed_response/Movie_detailed_response.dart';
import 'package:movies_app/api/movie_response/Movies.dart';
import 'package:movies_app/api/movie_response/Movies_response.dart';
import 'package:movies_app/core/sources/colors_manager.dart';

class MovieItem extends StatelessWidget {
  const MovieItem({super.key, required this.movie, this.onNavigateBack});
  final Movies movie;
  final VoidCallback? onNavigateBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _goToMovieDetails(context);
      },
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  movie.mediumCoverImage ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: ColorsManager.darkGrey,
                    child: Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: ColorsManager.darkGrey.withValues(alpha: 0.85),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          movie.rating?.toString() ?? '0.0',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                        ),
                        SizedBox(width: 3),
                        Icon(
                          Icons.star,
                          color: ColorsManager.yellow,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToMovieDetails(BuildContext context) async {
    MoviesResponse moviesResponse = await ApiServices.getMovieSuggestions(movie.id.toString());
    List<Movies> similarMovies = moviesResponse.data?.movies ?? [];
    MovieDetailedResponse movieResponse = await ApiServices.getMovieDetails(movie.id.toString());
    Movie? movieDetailed = movieResponse.data!.movie;
    movieDetailed?.similarMovies = similarMovies;
    if (!context.mounted) return;
    await Navigator.pushNamed(context, '/movieDetails', arguments: movieDetailed);
    if (onNavigateBack != null) {
      onNavigateBack!();
    }
  }
}
