import 'package:flutter/material.dart';
import 'package:movies_app/api/movie_response/Movies.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/main_layout/movie_item/movie_item.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/models/user_model.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  UserModel currentUser = UserModel.loggedInUser!;
  late String avatarSeed;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    avatarSeed = currentUser.avatarName ?? " ";
  }

  @override
  Widget build(BuildContext context) {
    currentUser = UserModel.loggedInUser!;
    List<Map<String, dynamic>> movies = selectedTab == 0
        ? (currentUser.wishListMoviesIds ?? [])
        : (currentUser.watchedMoviesIds ?? []);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
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
                                  "https://api.dicebear.com/7.x/avataaars/png?seed=$avatarSeed",
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              currentUser.name ?? " ",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              (currentUser.wishListMoviesIds ?? []).length.toString(),
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Wish List",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              (currentUser.watchedMoviesIds ?? []).length.toString(),
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "History",
                              style: Theme.of(context).textTheme.labelMedium,
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
                            "Edit Profile",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              RoutesManager.updateProfile,
                            );
                            setState(() {
                              currentUser = UserModel.loggedInUser!;
                              avatarSeed = currentUser.avatarName ?? " ";
                            });
                          },
                          backgroundColor: ColorsManager.yellow,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: CustomElevatedButton(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Exit",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Icon(Icons.logout, color: Colors.white),
                            ],
                          ),
                          onPressed: () async {
                            await FirebaseServices.signOut(context);
                          },
                          backgroundColor: ColorsManager.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  DefaultTabController(
                    initialIndex: selectedTab,
                    length: 2,
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          selectedTab = index;
                        });
                      },
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      indicatorColor: ColorsManager.yellow,
                      tabs: [
                        Tab(
                          text: "Wish List",
                          icon: Icon(Icons.list, color: ColorsManager.yellow),
                        ),
                        Tab(
                          text: "History",
                          icon: Icon(Icons.folder, color: ColorsManager.yellow),
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
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Image.asset(ImageAssets.empty),
                        )
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            Movies movie = Movies.fromJson(movies[index]);
                            return MovieItem(
                              movie: movie,
                              onNavigateBack: () {
                                setState(() {
                                  currentUser = UserModel.loggedInUser!;
                                });
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
}
