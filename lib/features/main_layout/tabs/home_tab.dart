import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/Movies.dart';
import 'package:movies_app/api/movie_response/Movies_response.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/features/main_layout/genres_ids/genres_ids.dart';
import 'package:movies_app/features/main_layout/movie_item/movie_item.dart';
import 'package:movies_app/features/main_layout/widgets/genre_section.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late PageController _pageController;
  late Future<MoviesResponse> moviesResponse;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.55, initialPage: 8);
    _currentPage = 8.0;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 8.0;
      });
    });
    moviesResponse = ApiServices.getMovieResponse();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: moviesResponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError ||
            snapshot.data?.data == null ||
            snapshot.data!.data!.movies == null ||
            snapshot.data!.data!.movies!.isEmpty) {
          return const Center(child: Text("No movies found"));
        }
        List<Movies> movies = snapshot.data!.data!.movies!.take(15).toList();
        int currentIndex = _currentPage.round().clamp(0, movies.length - 1);
        String? currentBg = movies[currentIndex].backgroundImage ??
            movies[currentIndex].mediumCoverImage;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 580,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (currentBg != null)
                      Image.network(
                        currentBg,
                        fit: BoxFit.cover,
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
                        SizedBox(height: 12),
                        Image.asset(ImageAssets.availableNow, height: 35),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 380,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: movies.length,
                            allowImplicitScrolling: true,
                            itemBuilder: (context, index) {
                              double value = (1 - (_currentPage - index).abs() * 0.3)
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
                        SizedBox(height: 12),
                        Image.asset(ImageAssets.watchNow, height: 35),
                        SizedBox(height: 12),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              ...GenresIds.genres.take(5).map((genre) => GenreSection(genre: genre)),
              SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
