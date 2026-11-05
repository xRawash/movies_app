import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/repos/auth_repo/auth_repo.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepo _authRepo;

  AuthViewModel({required this._authRepo});

  String? errorMessage;
  bool isLoading = false;

  Future<void> login(String email,
      String password,
      BuildContext context,
      GlobalKey<FormState> key,) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _authRepo.login(email, password, context, key);
    } catch (e) {
      errorMessage = e.toString().substring(11);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      return await _authRepo.loginWithGoogle(context);
    } catch (e) {
      errorMessage = e.toString().substring(11);
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> register(String name,
      String email,
      String password,
      String phoneNumber,
      BuildContext context,
      String avatarName,
      GlobalKey<FormState> key,) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _authRepo.register(
        name,
        email,
        password,
        phoneNumber,
        context,
        avatarName,
        key,
      );
    } catch (e) {
      errorMessage = e.toString().substring(11);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> signUpWithGoogle(String phoneNumber,
      BuildContext context,) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      return await _authRepo.signUpWithGoogle(phoneNumber, context);
    } catch (e) {
      errorMessage = e.toString().substring(11);
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> resetPassword (String email,BuildContext context,) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _authRepo.resetPassword( email, context);
    } catch (e) {
      errorMessage = e.toString().substring(11);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}