import 'package:flutter/material.dart';
import 'package:movies_app/firebase/firebase_services.dart';

class UpdateProfileRepo {
  Future<void> updateAccount (BuildContext context) async {
    await FirebaseServices.updateProfile(context);
  }
  Future<void> deleteAccount (BuildContext context) async {
    await FirebaseServices.deleteAccount(context);
  }
}