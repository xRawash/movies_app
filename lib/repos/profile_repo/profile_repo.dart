import 'package:flutter/material.dart';
import 'package:movies_app/firebase/firebase_services.dart';

class ProfileRepo {
  Future<bool> signOut(BuildContext context) async {
    return await FirebaseServices.signOut(context);
  }
}
