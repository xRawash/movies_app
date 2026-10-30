import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_response/Movies.dart';
import 'package:movies_app/api/movie_response/Movies_response.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/features/main_layout/genres_ids/genres_ids.dart';
import 'package:movies_app/features/main_layout/movie_item/movie_item.dart';
import 'package:movies_app/features/main_layout/widgets/custom_tab_bar.dart';

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
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  );
                }
                List<Movies> movies = snapshot.data!.data!.movies!;
                return GridView.builder(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
