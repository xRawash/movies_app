import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/movies.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/movie_item/movie_item.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/repos/profile_repo/profile_repo.dart';
import 'package:movies_app/view_models/profile_view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(profileRepo: ProfileRepo()),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if(viewModel.isLoading == true) {
            return Center(child: CircularProgressIndicator(color: ColorsManager.yellow,));
          }
          final movies = viewModel.moviesList();
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 50,
                      left: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    color: ColorsManager.darkGrey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: CircleAvatar(
                                      child: Image.network(
                                        viewModel.getAvatarLink() ?? "",
                                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    viewModel.currentUser.name ?? " ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    (viewModel.currentUser.wishListMovies ?? [])
                                        .length
                                        .toString(),
                                    style: Theme.of(context).textTheme.labelLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    l10n.wishList,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    (viewModel.currentUser.watchedMovies ?? [])
                                        .length
                                        .toString(),
                                    style: Theme.of(context).textTheme.labelLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    l10n.history,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 23),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomElevatedButton(
                                title: Text(
                                  l10n.editProfile,
                                  style: Theme.of(context).textTheme.titleMedium!
                                      .copyWith(fontWeight: FontWeight.normal),
                                ),
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    RoutesManager.updateProfile,
                                  );
                                  if(!context.mounted) return;
                                  context
                                      .read<ProfileViewModel>()
                                      .updateCurrentUser();
                                },
                                backgroundColor: ColorsManager.yellow,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: CustomElevatedButton(
                                title: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l10n.exit,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    Icon(Icons.logout, color: Colors.white),
                                  ],
                                ),
                                onPressed: () async {
                                  await context.read<ProfileViewModel>().signOut(
                                    context,
                                  );
                                },
                                backgroundColor: ColorsManager.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        DefaultTabController(
                          initialIndex: viewModel.selectedTab,
                          length: 2,
                          child: TabBar(
                            onTap: (index) {
                              context.read<ProfileViewModel>().changeSelectedTab(
                                index,
                              );
                            },
                            indicatorSize: TabBarIndicatorSize.tab,
                            unselectedLabelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            indicatorColor: ColorsManager.yellow,
                            tabs: [
                              Tab(
                                text: l10n.wishList,
                                icon: Icon(
                                  Icons.list,
                                  color: ColorsManager.yellow,
                                ),
                              ),
                              Tab(
                                text: l10n.history,
                                icon: Icon(
                                  Icons.folder,
                                  color: ColorsManager.yellow,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        movies.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 40.0,
                          ),
                          child: Image.asset(ImageAssets.empty),
                        )
                            : GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            Movies movie = Movies.fromJson(
                              movies[index],
                            );
                            return MovieItem(
                              movie: movie,
                              onNavigateBack: () {
                                context
                                    .read<ProfileViewModel>()
                                    .updateCurrentUser();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
