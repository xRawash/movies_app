import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/repos/movie_repo/movie_repo.dart';
import 'package:movies_app/repos/movie_repo/movie_repo_impl.dart';
import 'package:movies_app/view_models/search_view_model/search_view_model.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return ChangeNotifierProvider(
      create: (_) => SearchViewModel(movieRepo: MovieRepoImpl()),
      child: Builder(
        builder: (context) =>
         SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(
                  controller: _searchController,
                  hint: l10n.search,
                  prefixIcon: Icon(Icons.search),
                  onChanged: (value) {
                   context.read<SearchViewModel>().searchMovies(value);
                  },
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Consumer<SearchViewModel>(
                    builder: (context, viewModel, child){
                      if(viewModel.query.isEmpty){
                        return Center(
                          child: Text(
                            l10n.searchForFavoriteMovies,
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        );

                      }
                      if(viewModel.isLoading){
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorsManager.yellow,
                          ),
                        );

                      }
                      if(viewModel.errorMessage != null) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(viewModel.errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16),),
                              const SizedBox(height: 12,),
                              CustomElevatedButton(title: Text("Try Again"), onPressed: (){viewModel.searchMovies(_searchController.text);}, backgroundColor: ColorsManager.yellow)
                            ],
                          ),
                        );
                      }
                      if(viewModel.movies.isEmpty){
                        return Center(
                          child: Text(
                            l10n.noMoviesFound,
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        );
                      }
                      bool isLoading = viewModel.isLoading;
                      List<Movies> movies = viewModel.movies.isNotEmpty
                          ? viewModel.movies
                          : List.generate(10, (index) => Movies(title: "Loading Movie", rating: 0.0, year: 2024, mediumCoverImage: ""));
                      return Skeletonizer(
                        enabled: isLoading,
                        child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12,),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            return MovieItem(movie: movies[index]);
                          },
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
