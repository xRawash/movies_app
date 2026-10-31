import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_detailed_response/Movie.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/main_layout/movie_item/movie_item.dart';
import 'package:movies_app/features/main_layout/widgets/custom_card.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.bookmark_outline_sharp),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentGeometry.center,
              children: [
                Image(
                  image: NetworkImage(movie.largeCoverImage ?? ''),
                  opacity: const AlwaysStoppedAnimation(0.3),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.play_circle_filled_sharp),
                      color: ColorsManager.yellow,
                      iconSize: 100,
                    ),
                    Text(
                      movie.title ?? "",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      movie.year.toString(),
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
                    onPressed: () {},
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
                                  movie.likeCount.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 14),
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
                                  movie.runtime.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 14),
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
                                  movie.rating.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 14),
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
                        movie.mediumScreenshotImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: movie.mediumScreenshotImages.length,
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
                        MovieItem(movie: movie.similarMovies[index]),
                    itemCount: movie.similarMovies.length,
                  ),
                  Text(
                    "Summary",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    movie.descriptionFull ?? "",
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
                              movie.cast![index].urlSmallImage ?? "",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 60,
                                height: 60,
                                color: ColorsManager.darkGrey,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name : ${movie.cast![index].name ?? ""}",
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
                                  "Character : ${movie.cast![index].characterName ?? ""}",
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
                    itemCount: movie.cast!.length,
                  ),
                  Text(
                    "Genres",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: movie.genres!
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
    );
  }
}
