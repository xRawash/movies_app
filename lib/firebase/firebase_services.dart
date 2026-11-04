import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/models/user_model.dart';

class FirebaseServices {
  static CollectionReference<Map<String, dynamic>> _getUsersCollectionReference() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection('users');
  }

  static Future<void> addUserToFirestore(UserModel user) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      user.id,
    );
    return userDocument.set(user.toJson());
  }

  static Future<UserModel?> getCurrentUser(String userId) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> usersDoc = usersCollection.doc(
      userId,
    );
    DocumentSnapshot<Map<String, dynamic>> snapshot = await usersDoc.get();
    Map<String, dynamic>? data = snapshot.data();
    return data == null ? null : UserModel.fromJson(data);
  }

  static void register(String name, String email, String password, String phoneNumber, BuildContext context, String avatarName, GlobalKey<FormState> key,) async {
    if (key.currentState!.validate() == false) return;
    var l10n = AppLocalizations.of(context)!;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel user = UserModel(
        name: name,
        email: email,
        phone: phoneNumber,
        id: userCredential.user!.uid,
        avatarName: avatarName,
      );
      try {
        await addUserToFirestore(user);
      } catch (e) {
        await FirebaseAuth.instance.currentUser!.delete();
        Utilities.showToast(l10n.signUpFailed);
        return;
      }

      if (!context.mounted) {
        return null;
      }
      Utilities.showToast(l10n.accountCreatedSuccessfully);
      Navigator.pushReplacementNamed(context, RoutesManager.login);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          Utilities.showToast(l10n.emailAlreadyInUse);
          break;
        case 'weak-password':
          Utilities.showToast(l10n.weakPassword);
          break;
        case 'invalid-email':
          Utilities.showToast(l10n.invalidEmail);
          break;
        case 'network-request-failed':
          Utilities.showToast(l10n.networkError);
          break;
        default:
          Utilities.showToast(l10n.signUpFailed);
      }
    } on FirebaseException {
      Utilities.showToast(l10n.signUpFailed);
    } catch (e) {
      Utilities.showToast(l10n.somethingWentWrong);
    }
  }

  static void login(String email, String password, BuildContext context, GlobalKey<FormState> key,) async {
    if (key.currentState!.validate() == false) return;
    var l10n = AppLocalizations.of(context)!;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = await getCurrentUser(userCredential.user!.uid);
      if (user == null) {
        await FirebaseAuth.instance.signOut();
        Utilities.showToast(l10n.noProfileFound);
        return;
      }
      UserModel.loggedInUser = user;
      if (!context.mounted) {
        return null;
      }
      Utilities.showToast(l10n.loggedInSuccessfully);
      Navigator.pushReplacementNamed(context, RoutesManager.mainScreen);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          Utilities.showToast(l10n.wrongEmailOrPassword);
          break;
        case 'user-disabled':
          Utilities.showToast(l10n.accountDisabled);
          break;
        case 'too-many-requests':
          Utilities.showToast(l10n.tooManyAttempts);
          break;
        case 'network-request-failed':
          Utilities.showToast(l10n.networkError);
          break;
        default:
          Utilities.showToast(l10n.loginFailed);
      }
    } on FirebaseException {
      Utilities.showToast(l10n.couldNotLoadProfile);
    } catch (e) {
      Utilities.showToast(l10n.somethingWentWrong);
    }
  }

  static Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    var l10n = AppLocalizations.of(context)!;
    try {
      GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();
      GoogleSignInAuthentication googleAuth = googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final user = await getCurrentUser(userCredential.user!.uid);
      if (user == null) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn.instance.signOut();
        Utilities.showToast(l10n.noAccountFound);
        return null;
      }
      UserModel.loggedInUser = user;
      if (!context.mounted) return userCredential;
      Utilities.showToast(l10n.loggedInSuccessfully);
      Navigator.pushReplacementNamed(context, RoutesManager.mainScreen);
      return userCredential;
    } on GoogleSignInException catch (e) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          Utilities.showToast(l10n.signInCancelled);
          break;
        default:
          Utilities.showToast(l10n.googleSignInFailed);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          Utilities.showToast(l10n.accountExistsDifferentCredential);
          break;
        case 'invalid-credential':
          Utilities.showToast(l10n.invalidGoogleCredential);
          break;
        case 'user-disabled':
          Utilities.showToast(l10n.accountDisabled);
          break;
        case 'network-request-failed':
          Utilities.showToast(l10n.networkError);
          break;
        default:
          Utilities.showToast(l10n.signInCancelled);
      }
      return null;
    } catch (e) {
      Utilities.showToast(l10n.googleSignInFailed);
      return null;
    }
  }

  static Future<UserCredential?> signUpWithGoogle(String phoneNumber, BuildContext context,) async {
    var l10n = AppLocalizations.of(context)!;
    try {
      GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();
      GoogleSignInAuthentication googleAuth = googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final firebaseUser = userCredential.user!;
      final existing = await getCurrentUser(firebaseUser.uid);

      if (existing == null) {
        final user = UserModel(
          name: googleUser.displayName,
          id: firebaseUser.uid,
          email: googleUser.email,
          phone: phoneNumber,
        );
       try {
          await addUserToFirestore(user);
        } catch (e) {
          await FirebaseAuth.instance.currentUser!.delete();
          Utilities.showToast(l10n.signUpFailed);
       }
        if (!context.mounted) return userCredential;
        Utilities.showToast(l10n.accountCreatedSuccessfully);
        Navigator.pushReplacementNamed(context, RoutesManager.login);
      } else {
        UserModel.loggedInUser = existing;
        if (!context.mounted) return userCredential;
        Utilities.showToast(l10n.welcomeBack);
        Navigator.pushReplacementNamed(context, RoutesManager.mainScreen);
      }
      return userCredential;
    } on GoogleSignInException catch (e) {
      debugPrint('GoogleSignInException: ${e.code} | ${e.description}');
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          Utilities.showToast(l10n.signUpCancelled);
          break;
        default:
          Utilities.showToast(l10n.googleSignInFailed);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          Utilities.showToast(l10n.accountExistsDifferentCredential);
          break;
        case 'invalid-credential':
          Utilities.showToast(l10n.invalidGoogleCredential);
          break;
        case 'user-disabled':
          Utilities.showToast(l10n.accountDisabled);
          break;
        case 'network-request-failed':
          Utilities.showToast(l10n.networkError);
          break;
        default:
          Utilities.showToast(l10n.googleSignInFailed);
      }
      return null;
    } catch (e) {
      Utilities.showToast(l10n.somethingWentWrong);
      return null;
    }
  }

  static Future<bool> signOut(BuildContext context) async {
    var l10n = AppLocalizations.of(context)!;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        Utilities.showToast(l10n.networkError);
        return false;
      }
    } catch (_) {
      Utilities.showToast(l10n.networkError);
      return false;
    }

    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();
      Utilities.showToast(l10n.loggedOutSuccessfully);
      UserModel.loggedInUser = null;
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          Utilities.showToast(l10n.networkError);
          break;
        default:
          Utilities.showToast(l10n.signOutFailed);
      }
      return false;
    } catch (e) {
      Utilities.showToast(l10n.signOutFailed);
      return false;
    }
  }


  static Future<void> deleteAccount() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      Utilities.showToast('No authenticated user found.');
    }

    final userId = firebaseUser!.uid;
    final userDocument = _getUsersCollectionReference().doc(userId);

    try {
      await userDocument.delete();

      await firebaseUser.delete();

      UserModel.loggedInUser = null;

      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        Utilities.showToast('Error signing out from Google: $e');
      }

    } on FirebaseAuthException {
      rethrow;
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<void> updateProfile({required String name, required String phone, required String avatarSeed}) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    await userDocument.update(
      {
        'name': name,
        'phone': phone,
        'avatarName': avatarSeed,
      },
    );
  }

  static Future<void> addMovieToWishList(Movie movie) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    bool exists = UserModel.loggedInUser!.wishListMovies!
        .any((item) => item['id'] == movie.id);
    if (!exists) {
      UserModel.loggedInUser!.wishListMovies!.add(movie.toJson());
      await userDocument.update(UserModel.loggedInUser!.toJson());
    }
  }

  static Future<void> addMovieToHistory(Movie movie) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDox = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    bool exists = UserModel.loggedInUser!.watchedMovies!
        .any((item) => item['id'] == movie.id);
    if (!exists) {
      UserModel.loggedInUser!.watchedMovies!.add(movie.toJson());
      await userDox.update(UserModel.loggedInUser!.toJson());
    }
  }

  static Future<void> removeMovieFromWishList(Movie movie) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    await userDocument.update(UserModel.loggedInUser!.toJson());
    // UserModel.loggedInUser!.wishListMovies!
    //     .removeWhere((item) => item['id'] == movie.id);
  }

  static Future<void> resetPassword(String email, BuildContext context) async {
    var l10n = AppLocalizations.of(context)!;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      Utilities.showToast(l10n.passwordResetEmailSent);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          Utilities.showToast(l10n.invalidEmail);
          break;
        case 'user-not-found':
          Utilities.showToast(l10n.noUserFoundWithEmail);
          break;
        case 'network-request-failed':
          Utilities.showToast(l10n.networkError);
          break;
        default:
          Utilities.showToast(l10n.passwordResetFailed);
      }
    } catch (e) {
      Utilities.showToast(l10n.passwordResetFailed);
    }
  }
}
