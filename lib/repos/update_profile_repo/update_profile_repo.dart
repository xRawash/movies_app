
import 'package:flutter/material.dart';
import 'package:movies_app/firebase/firebase_services.dart';

class UpdateProfileRepo {
  Future<void> updateAccount(
      {
    required String name,
    required String phone,
    required String avatarSeed,
  }) async {
    await FirebaseServices.updateProfile(
      name: name,
      phone: phone,
      avatarSeed: avatarSeed,
    );
  }

  Future<void> deleteAccount() async {
    await FirebaseServices.deleteAccount();
  }
}
