import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/repos/auth_repo/auth_repo.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepo _authRepo;

  AuthViewModel({required this._authRepo});

  String? errorMessage;
  bool isLoading = false;

  Future<bool> login(String email,
      String password,) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _authRepo.login(email, password);
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      return await _authRepo.loginWithGoogle();
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<bool> register(String name,
      String email,
      String password,
      String phoneNumber,
      String avatarName,) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _authRepo.register(
        name,
        email,
        password,
        phoneNumber,
        avatarName,
      );
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> signUpWithGoogle(String phoneNumber,
      ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      return await _authRepo.signUpWithGoogle(phoneNumber,);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<bool> resetPassword (String email ,) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _authRepo.resetPassword( email,);
      return true;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}