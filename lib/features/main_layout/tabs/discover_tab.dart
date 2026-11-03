import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/main_layout/genres_ids/genres_ids.dart';
import 'package:movies_app/features/main_layout/widgets/custom_tab_bar.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';
import 'package:movies_app/view_models/discover_view_model/discover_view_model.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  String selectedGenre = GenresIds.genres.first;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          DiscoverViewModel(movieRepo: MovieRepo())
            ..loadMoviesByGenre(selectedGenre),
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),

                CustomTabBar(
                  genres: GenresIds.genres,
                  selectedBgColor: ColorsManager.yellow,
                  unselectedBgColor: Colors.transparent,
                  selectedFgColor: ColorsManager.black,
                  unSelectedFgColor: ColorsManager.yellow,
                  initialGenre: selectedGenre,
                  onSelectedGenreChanged: (genre) {
                    if (genre == selectedGenre) return;

                    setState(() {
                      selectedGenre = genre;
                    });

                    context.read<DiscoverViewModel>().loadMoviesByGenre(genre);
                  },
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: Consumer<DiscoverViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.errorMessage != null &&
                          viewModel.movies.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Error loading movies',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              CustomElevatedButton(
                                title: const Text('Try Again'),
                                onPressed: () {
                                  viewModel.loadMoviesByGenre(selectedGenre);
                                },
                                backgroundColor: ColorsManager.yellow,
                              ),
                            ],
                          ),
                        );
                      }

                      if (!viewModel.isLoading && viewModel.movies.isEmpty) {
                        return const Center(
                          child: Text(
                            'No movies found',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final List<Movies> movies = viewModel.movies.isNotEmpty
                          ? viewModel.movies
                          : List.generate(
                              10,
                              (index) => Movies(
                                title: 'Loading Movie',
                                rating: 0.0,
                                year: 2024,
                                mediumCoverImage: '',
                              ),
                            );

                      return Skeletonizer(
                        enabled: viewModel.isLoading,
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
              ],
            ),
          );
        },
      ),
    );
  }
}
