import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/repos/auth_repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  @override
  Future<bool> login(String email, String password) async {
    return await FirebaseServices.login(email, password);
  }

  @override
  Future<UserCredential?> loginWithGoogle() async {
    return await FirebaseServices.loginWithGoogle();
  }

  @override
  Future<bool> register(String name, String email, String password, String phoneNumber, String avatarName) async {
    return await FirebaseServices.register(name, email, password, phoneNumber, avatarName);
  }

  @override
  Future<bool> resetPassword(String email, ) async {
    return await FirebaseServices.resetPassword(email,);
  }

  @override
  Future<UserCredential?> signUpWithGoogle(String phoneNumber) async {
    return await FirebaseServices.signUpWithGoogle(phoneNumber);
  }
}