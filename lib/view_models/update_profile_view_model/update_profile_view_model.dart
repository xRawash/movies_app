import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/user_model.dart';
import 'package:movies_app/repos/update_profile_repo/update_profile_repo.dart';

class UpdateProfileViewModel extends ChangeNotifier {
  final UpdateProfileRepo _updateProfileRepo;

  UpdateProfileViewModel({required this._updateProfileRepo}) {
    final user = UserModel.loggedInUser!;
    name = user.name ?? '';
    phone = user.phone ?? '';
    avatarSeed = user.avatarName ?? 'default';
  }

  late String name;
  late String phone;
  late String avatarSeed;

  bool isLoading = false;
  String? errorMessage;

  String getAvatarLink(String seed) {
    return 'https://api.dicebear.com/7.x/avataaars/png?seed=$seed';
  }

  void changeAvatarSeed(String seed) {
    avatarSeed = seed;
    notifyListeners();
  }

  Future<bool> updateAccount({
    required String newName,
    required String newPhone,
  }) async {
    if (isLoading) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _updateProfileRepo.updateAccount(
        name: newName,
        phone: newPhone,
        avatarSeed: avatarSeed,
      );

      final user = UserModel.loggedInUser!;
      user.name = newName;
      user.phone = newPhone;
      user.avatarName = avatarSeed;

      name = newName;
      phone = newPhone;

      return true;
    } on TimeoutException {
      errorMessage = 'Request timed out. Please try again.';
      return false;
    } on FirebaseException catch (e) {
      errorMessage = e.message ?? 'Something went wrong. Please try again.';
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally{
      isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> deleteAccount() async {
    if (isLoading) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _updateProfileRepo.deleteAccount();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        errorMessage = 'Please sign in again before deleting your account.';
      } else {
        errorMessage = e.message ?? 'Account deletion failed.';
      }
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
