import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/api/movie_response/movies_response.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/features/main_layout/genres_ids/genres_ids.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/provider/config_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    String title = GenresIds.getLocalizedGenre(context, widget.genre);
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context);
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
                onPressed: () {
                  Navigator.pushNamed(context, RoutesManager.moviesByGenre, arguments: {'genreId': widget.genre});
                },
                child: Text(
                  configProvider.currentLanguage == 'en' ?
                  "${AppLocalizations.of(context)!.seeMore}  →" : "${AppLocalizations.of(context)!.seeMore}  ←" ,
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
              bool isLoading = snapshot.connectionState == ConnectionState.waiting;
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error loading",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              List<Movies> movies = (snapshot.hasData && snapshot.data?.data?.movies != null)
                  ? snapshot.data!.data!.movies!.take(15).toList()
                  : List.generate(
                      6,
                      (index) => Movies(
                        title: "Loading Movie",
                        rating: 0.0,
                        year: 2024,
                        mediumCoverImage: "",
                      ),
                    );

              return Skeletonizer(
                enabled: isLoading,
                child: ListView.builder(
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
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
