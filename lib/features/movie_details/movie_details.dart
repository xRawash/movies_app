import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/main_layout/genres_ids/genres_ids.dart';
import 'package:movies_app/features/main_layout/widgets/custom_card.dart';
import 'package:movies_app/features/movie_details/widgets/movie_bookmark.dart';
import 'package:movies_app/features/movie_details/widgets/resolution_dialog.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';
import 'package:movies_app/repos/movie_repo/movie_repo_impl.dart';
import 'package:movies_app/view_models/movie_detail_view_model/movie_detail_view_model.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  Movies? nonDetailedMovie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    nonDetailedMovie ??= ModalRoute.of(context)!.settings.arguments as Movies;
  }

  @override
  Widget build(BuildContext context) {
    if (nonDetailedMovie == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    var l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider(
      create: (_) =>
          MovieDetailViewModel(movieRepo: MovieRepoImpl())
            ..getMovieDetails(nonDetailedMovie!.id.toString()),
      child: Consumer<MovieDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.errorMessage != null && viewModel.movie == null) {
            return const Center(
              child: Text(
                "Error loading movie details",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (!viewModel.isLoading && viewModel.movie == null) {
            return const Center(
              child: Text(
                "No movie details found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final bool isLoading = viewModel.isLoading;
          Movie detailedMovie =
              viewModel.movie ??
              Movie(
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
                actions: [MovieBookmark(movie: detailedMovie)],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentGeometry.center,
                      children: [
                        Image(
                          image: NetworkImage(
                            detailedMovie.largeCoverImage ?? '',
                          ),
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
                              l10n.watch,
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
                                      Icon(
                                        Icons.favorite,
                                        color: ColorsManager.yellow,
                                      ),
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
                                      Icon(
                                        Icons.star,
                                        color: ColorsManager.yellow,
                                      ),
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
                            l10n.screenshots,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: detailedMovie.mediumScreenshotImages.isNotEmpty
                                  ? Image.network(
                                detailedMovie.mediumScreenshotImages[index],
                                fit: BoxFit.cover,
                              ) : Icon(Icons.image),
                            ),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemCount:
                                detailedMovie.mediumScreenshotImages.isNotEmpty
                                ? detailedMovie.mediumScreenshotImages.length
                                : 2,
                          ),
                          Text(
                            l10n.similar,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.65,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemBuilder: (context, index) => MovieItem(
                              movie: detailedMovie.similarMovies[index],
                            ),
                            itemCount: detailedMovie.similarMovies.length,
                          ),
                          Text(
                            l10n.summary,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            detailedMovie.descriptionFull ?? "",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          Text(
                            l10n.cast,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
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
                                      detailedMovie.cast != null &&
                                              detailedMovie.cast!.isNotEmpty
                                          ? detailedMovie
                                                    .cast![index]
                                                    .urlSmallImage ??
                                                ""
                                          : '',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10),
                            itemCount:
                                detailedMovie.cast != null &&
                                    detailedMovie.cast!.isNotEmpty
                                ? detailedMovie.cast!.length
                                : 3,
                          ),
                          Text(
                            l10n.genres,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                (detailedMovie.genres != null &&
                                            detailedMovie.genres!.isNotEmpty
                                        ? detailedMovie.genres!
                                        : ['Action', 'Drama', 'Sci-Fi'])
                                    .map(
                                      (genre) => CustomCard(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          GenresIds.getLocalizedGenre(
                                            context,
                                            genre,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
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
      ),
    );
  }
}
