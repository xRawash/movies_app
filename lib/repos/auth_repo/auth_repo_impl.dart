import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/repos/auth_repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  @override
  Future<void> login(String email, String password, BuildContext context, GlobalKey<FormState> key) async {
    await FirebaseServices.login(email, password, context, key);
  }

  @override
  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    return await FirebaseServices.loginWithGoogle(context);
  }

  @override
  Future<void> register(String name, String email, String password, String phoneNumber, BuildContext context, String avatarName, GlobalKey<FormState> key) async {
    await FirebaseServices.register(name, email, password, phoneNumber, context, avatarName, key);
  }

  @override
  Future<void> resetPassword(String email, BuildContext context) async {
    await FirebaseServices.resetPassword(email, context);
  }

  @override
  Future<UserCredential?> signUpWithGoogle(String phoneNumber, BuildContext context) async {
    return await FirebaseServices.signUpWithGoogle(phoneNumber, context);
  }
}