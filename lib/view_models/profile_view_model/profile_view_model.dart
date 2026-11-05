import 'package:flutter/material.dart';
import 'package:movies_app/models/user_model.dart';
import 'package:movies_app/repos/profile_repo/profile_repo.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepo _profileRepo;

  ProfileViewModel({required this._profileRepo});

  bool isLoading = false;
  String? errorMessage;

  UserModel currentUser = UserModel.loggedInUser!;
  int selectedTab = 0;

  Future<bool> signOut() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _profileRepo.signOut();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? getAvatarLink() {
    final seed = currentUser.avatarName ?? "default";
    final avatarLink =
        "https://api.dicebear.com/7.x/avataaars/png?seed=$seed";
    return avatarLink;
  }

  List<Map<String, dynamic>> moviesList() {
    return selectedTab == 0
        ? (currentUser.wishListMovies ?? [])
        : (currentUser.watchedMovies ?? []);
  }

  void changeSelectedTab(int newIndex) {
    if (selectedTab == newIndex) return;
    selectedTab = newIndex;
    notifyListeners();
  }

  void updateCurrentUser() {
    final user = UserModel.loggedInUser;

    if (user == null) return;

    currentUser = user;
    notifyListeners();
  }
}
