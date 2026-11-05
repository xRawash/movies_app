import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRepo {
  Future<void> login (String email, String password, BuildContext context, GlobalKey<FormState> key,);
  Future<UserCredential?> loginWithGoogle (BuildContext context);
  Future<void> register (String name, String email, String password, String phoneNumber, BuildContext context, String avatarName, GlobalKey<FormState> key,);
  Future<UserCredential?> signUpWithGoogle (String phoneNumber, BuildContext context,);
  Future<void> resetPassword (String email, BuildContext context,);
}