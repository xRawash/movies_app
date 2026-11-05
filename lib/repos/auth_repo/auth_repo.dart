import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Future<bool> login (String email, String password,);
  Future<UserCredential?> loginWithGoogle ();
  Future<bool> register (String name, String email, String password, String phoneNumber, String avatarName,);
  Future<UserCredential?> signUpWithGoogle (String phoneNumber,);
  Future<bool> resetPassword (String email,);
}