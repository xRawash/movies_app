import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/main_layout/genres_ids/genres_ids.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/provider/config_provider.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';
import 'package:movies_app/repos/movie_repo/movie_repo_impl.dart';
import 'package:movies_app/view_models/genre_view_model/genre_view_model.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GenreSection extends StatefulWidget {
  const GenreSection({super.key, required this.genre});

  final String genre;

  @override
  State<GenreSection> createState() => _GenreSectionState();
}

class _GenreSectionState extends State<GenreSection> {


  @override
  void initState() {
    super.initState();

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
          child: ChangeNotifierProvider(
            create: (_) => GenreViewModel(movieRepo: MovieRepoImpl())..loadMoviesByGenre(widget.genre),
            child: Consumer<GenreViewModel>(
              builder: (context, viewModel, child) {
                if(viewModel.errorMessage != null && viewModel.movies.isEmpty) {
                  return const Center(
                    child: Text(
                      "Error loading movies",
                      style: TextStyle(color: Colors.white),
                    ),
                  );

                }
                const SizedBox(height: 20,);
                CustomElevatedButton(title: Text("Try Again"), onPressed: (){context.read<GenreViewModel>().loadMoviesByGenre(widget.genre);}, backgroundColor: ColorsManager.yellow);
                if(!viewModel.isLoading && viewModel.movies.isEmpty){
                  return const Center(
                    child: Text(
                      "No movies found",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                bool isLoading = viewModel.isLoading;
                final List<Movies> movies = viewModel.movies.isNotEmpty
                    ? viewModel.movies.take(6).toList()
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
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
