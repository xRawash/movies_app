import 'package:flutter/material.dart';
import 'package:movies_app/api/api_services.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/api/movie_detailed_response/movie_detailed_response.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/main_layout/widgets/custom_card.dart';
import 'package:movies_app/features/movie_details/widgets/movie_bookmark.dart';
import 'package:movies_app/features/movie_details/widgets/resolution_dialog.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Future<MovieDetailedResponse> _movieDetailsFuture;
  Movies? nonDetailedMovie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (nonDetailedMovie == null) {
      nonDetailedMovie = ModalRoute.of(context)!.settings.arguments as Movies;
      _movieDetailsFuture = ApiServices.getMovieDetails(nonDetailedMovie!.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (nonDetailedMovie == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return FutureBuilder<MovieDetailedResponse>(
      future: _movieDetailsFuture,
      builder: (context, snapshot) {
        bool isLoading = snapshot.connectionState == ConnectionState.waiting;
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: Center(child: Text("Error loading details", style: TextStyle(color: Colors.white))),
          );
        }

        Movie detailedMovie;
        if (snapshot.hasData && snapshot.data?.data?.movie != null) {
          detailedMovie = snapshot.data!.data!.movie!;
        } else {
          detailedMovie = Movie(
            title: nonDetailedMovie!.title ?? "Loading Title...",
            year: nonDetailedMovie!.year ?? 2024,
            rating: nonDetailedMovie!.rating ?? 0.0,
            likeCount: 0,
            runtime: 0,
            descriptionFull: "Loading movie description...",
            largeCoverImage: nonDetailedMovie!.largeCoverImage,
            mediumCoverImage: nonDetailedMovie!.mediumCoverImage,
            genres: ['Action', 'Drama'],
            cast: [],
            torrents: [],
          );
        }

        return Skeletonizer(
          enabled: isLoading,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
                color: Colors.white,
              ),
              actions: [
                MovieBookmark(movie: detailedMovie)
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      Image(
                        image: NetworkImage(detailedMovie.largeCoverImage ?? ''),
                        opacity: const AlwaysStoppedAnimation(0.3),
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              showResolutionDialog(context, detailedMovie);
                            },
                            icon: Icon(Icons.play_circle_filled_sharp),
                            color: ColorsManager.yellow,
                            iconSize: 100,
                          ),
                          Text(
                            detailedMovie.title ?? "",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            detailedMovie.year.toString(),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomElevatedButton(
                          title: Text(
                            "Watch",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          onPressed: () {
                            showResolutionDialog(context, detailedMovie);
                          },
                          backgroundColor: ColorsManager.red,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CustomCard(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.favorite, color: ColorsManager.yellow),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        detailedMovie.likeCount.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: CustomCard(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time_filled_sharp,
                                      color: ColorsManager.yellow,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        detailedMovie.runtime.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: CustomCard(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: ColorsManager.yellow),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        detailedMovie.rating.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Screen Shots",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              detailedMovie.mediumScreenshotImages.isNotEmpty
                                  ? detailedMovie.mediumScreenshotImages[index]
                                  : '',
                              fit: BoxFit.cover,
                            ),
                          ),
                          separatorBuilder: (context, index) => SizedBox(height: 10),
                          itemCount: detailedMovie.mediumScreenshotImages.isNotEmpty
                              ? detailedMovie.mediumScreenshotImages.length
                              : 2,
                        ),
                        Text(
                          "Similar",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) =>
                              MovieItem(movie: detailedMovie.similarMovies[index]),
                          itemCount: detailedMovie.similarMovies.length,
                        ),
                        Text(
                          "Summary",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          detailedMovie.descriptionFull ?? "",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text("Cast", style: Theme.of(context).textTheme.labelMedium),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => CustomCard(
                            child: Row(
                              spacing: 15,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    detailedMovie.cast != null && detailedMovie.cast!.isNotEmpty
                                        ? detailedMovie.cast![index].urlSmallImage ?? ""
                                        : '',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                      width: 60,
                                      height: 60,
                                      color: ColorsManager.darkGrey,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name : ${detailedMovie.cast != null && detailedMovie.cast!.isNotEmpty ? detailedMovie.cast![index].name ?? "" : "Loading Name"}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Character : ${detailedMovie.cast != null && detailedMovie.cast!.isNotEmpty ? detailedMovie.cast![index].characterName ?? "" : "Loading Character"}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontSize: 13,
                                              color: Colors.white70,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          separatorBuilder: (context, index) => SizedBox(height: 10),
                          itemCount: detailedMovie.cast != null && detailedMovie.cast!.isNotEmpty
                              ? detailedMovie.cast!.length
                              : 3,
                        ),
                        Text(
                          "Genres",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: (detailedMovie.genres != null && detailedMovie.genres!.isNotEmpty
                                  ? detailedMovie.genres!
                                  : ['Action', 'Drama', 'Sci-Fi'])
                              .map(
                                (genre) => CustomCard(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    genre,
                                    style: Theme.of(context).textTheme.displaySmall,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
