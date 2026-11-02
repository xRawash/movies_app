import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/api/movie_response/movies_response.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/features/main_layout/genres_ids/genres_ids.dart';
import 'package:movies_app/features/main_layout/widgets/custom_tab_bar.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  String selectedGenre = GenresIds.genres.first;
  late Future<MoviesResponse> genreMoviesFuture;

  @override
  void initState() {
    super.initState();
    genreMoviesFuture = ApiServices.getMoviesByGenre(selectedGenre);
  }

  void _onGenreChanged(String genre) {
    setState(() {
      selectedGenre = genre;
      genreMoviesFuture = ApiServices.getMoviesByGenre(selectedGenre);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 16),
          CustomTabBar(
            genres: GenresIds.genres,
            selectedBgColor: ColorsManager.yellow,
            unselectedBgColor: Colors.transparent,
            selectedFgColor: ColorsManager.black,
            unSelectedFgColor: ColorsManager.yellow,
            initialGenre: selectedGenre,
            onSelectedGenreChanged: _onGenreChanged,
          ),
          SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<MoviesResponse>(
              future: genreMoviesFuture,
              builder: (context, snapshot) {
                bool isLoading = snapshot.connectionState == ConnectionState.waiting;
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Failed to load movies",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
        ],
      ),
    );
  }
}
