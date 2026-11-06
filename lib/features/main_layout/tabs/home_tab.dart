import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/main_layout/genres_ids/genres_ids.dart';
import 'package:movies_app/features/main_layout/widgets/genre_section.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:movies_app/repos/movie_repo/movie_repo_impl.dart';
import 'package:movies_app/view_models/home_view_model/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.55, initialPage: 0);
    _currentPage = 0.0;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
      HomeViewModel(movieRepo: MovieRepoImpl())
        ..loadMovies(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.errorMessage != null && viewModel.movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Error loading movies",
                    style: TextStyle(color: Colors.white),
                  ),const SizedBox(height: 12,),
                  CustomElevatedButton(title: Text("Try Again", style: Theme
                      .of(context)
                      .textTheme
                      .labelMedium,), onPressed: () {
                    context.read<HomeViewModel>().loadMovies();
                  }, backgroundColor: ColorsManager.yellow)
                ],
              ),
            );
          }

          if(!viewModel.isLoading && viewModel.movies.isEmpty){
            return const Center(
              child: Text(
                "No movies found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final bool isLoading = viewModel.isLoading;
          final List<Movies> movies =
         viewModel.movies.isNotEmpty
              ? viewModel.movies
              : List.generate(
            10,
                (index) =>
                Movies(
                  title: "Loading Movie",
                  rating: 0.0,
                  year: 2024,
                  mediumCoverImage: "",
                ),
          );

          final int currentIndex = _currentPage.round().clamp(0, movies.length - 1);
          String? currentBg = movies.isNotEmpty
              ? (movies[currentIndex].backgroundImage ??
              movies[currentIndex].mediumCoverImage)
              : null;

          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 580,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (currentBg != null && currentBg.isNotEmpty)
                          Image.network(
                            currentBg,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: Colors.black),
                          ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            Image.asset(ImageAssets.availableNow, height: 35),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 380,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: movies.length,
                                allowImplicitScrolling: true,
                                itemBuilder: (context, index) {
                                  double value =
                                  (1 - (_currentPage - index).abs() * 0.3)
                                      .clamp(0.7, 1.0);
                                  return Center(
                                    child: Transform.scale(
                                      scale: value,
                                      child: MovieItem(movie: movies[index]),
                                    ),
                                  );
                                },
                              ),
                            ),
                           const SizedBox(height: 12),
                            Image.asset(ImageAssets.watchNow, height: 35),
                           const SizedBox(height: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                 const SizedBox(height: 24),
                  ...GenresIds.genres
                      .take(5)
                      .map((genre) => GenreSection(genre: genre)),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
