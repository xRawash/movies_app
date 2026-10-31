import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/models/user_model.dart';

import '../core/sources/routes_manager.dart';

class FirebaseServices {
  static CollectionReference<Map<String, dynamic>>
  _getUsersCollectionReference() {
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

  static void register(
    String name,
    String email,
    String password,
    String phoneNumber,
    BuildContext context,
    String avatarName,
    GlobalKey<FormState> key,
  ) async {
    if (key.currentState!.validate() == false) return;
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
      await addUserToFirestore(user);
      if (!context.mounted) {
        return null;
      }
      Navigator.pushReplacementNamed(context, RoutesManager.login);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          Utilities.showToast('Email already used');
          break;
        case 'weak-password':
          Utilities.showToast('Password is too weak');
          break;
        case 'invalid-email':
          Utilities.showToast('Invalid email address');
          break;
        case 'network-request-failed':
          Utilities.showToast('Network error. Check your connection.');
          break;
        default:
          Utilities.showToast('Sign up failed. Please try again.');
      }
    } on FirebaseException {
      Utilities.showToast('Sign up failed. Please try again.');
    } catch (e) {
      Utilities.showToast('Something went wrong. Please try again.');
    }
  }

  static void login(
    String email,
    String password,
    BuildContext context,
    GlobalKey<FormState> key,
  ) async {
    if (key.currentState!.validate() == false) return;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = await getCurrentUser(userCredential.user!.uid);
      if (user == null) {
        await FirebaseAuth.instance.signOut();
        Utilities.showToast('No profile found for this account.');
        return;
      }
      UserModel.loggedInUser = user;
      if (!context.mounted) {
        return null;
      }
      Navigator.pushReplacementNamed(context, RoutesManager.mainScreen);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          Utilities.showToast('Wrong email or password.');
          break;
        case 'user-disabled':
          Utilities.showToast('This account has been disabled.');
          break;
        case 'too-many-requests':
          Utilities.showToast('Too many attempts. Try again later.');
          break;
        case 'network-request-failed':
          Utilities.showToast('Network error. Check your connection.');
          break;
        default:
          Utilities.showToast('Login failed. Please try again.');
      }
    } on FirebaseException {
      Utilities.showToast('Could not load your profile. Please try again.');
    } catch (e) {
      Utilities.showToast('Something went wrong. Please try again.');
    }
  }

  static Future<UserCredential?> loginWithGoogle(BuildContext context) async {
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
        Utilities.showToast('No account found. Please sign up first.');
        return null;
      }
      UserModel.loggedInUser = user;
      if (!context.mounted) return userCredential;
      Utilities.showToast('Logged In Successfully');
      Navigator.pushReplacementNamed(context, RoutesManager.mainScreen);
      return userCredential;
    } on GoogleSignInException catch (e) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          Utilities.showToast('Sign-in cancelled');
          break;
        default:
          Utilities.showToast('Google sign-in failed. Please try again.');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          Utilities.showToast(
            'An account already exists with a different sign-in method.',
          );
          break;
        case 'invalid-credential':
          Utilities.showToast('The Google credential is invalid or expired.');
          break;
        case 'user-disabled':
          Utilities.showToast('This account has been disabled.');
          break;
        case 'network-request-failed':
          Utilities.showToast('Network error. Check your connection.');
          break;
        default:
          Utilities.showToast('Sign-in failed. Please try again.');
      }
      return null;
    } catch (e) {
      Utilities.showToast('Sign-in failed. Please try again.');
      return null;
    }
  }

  static Future<UserCredential?> signUpWithGoogle(
    String phoneNumber,
    BuildContext context,
  ) async {
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
        await addUserToFirestore(user);
        UserModel.loggedInUser = user;
        if (!context.mounted) return userCredential;
        Utilities.showToast('Account Created Successfully');
        Navigator.pushReplacementNamed(context, RoutesManager.login);
      } else {
        UserModel.loggedInUser = existing;
        if (!context.mounted) return userCredential;
        Utilities.showToast('Welcome Back!');
        Navigator.pushReplacementNamed(context, RoutesManager.mainScreen);
      }
      return userCredential;
    } on GoogleSignInException catch (e) {
      debugPrint('GoogleSignInException: ${e.code} | ${e.description}');
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          Utilities.showToast('Sign-up cancelled');
          break;
        default:
          Utilities.showToast('Google sign-up failed: ${e.code.name}');
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          Utilities.showToast(
            'An account already exists with a different sign-in method.',
          );
          break;
        case 'invalid-credential':
          Utilities.showToast('The Google credential is invalid or expired.');
          break;
        case 'user-disabled':
          Utilities.showToast('This account has been disabled.');
          break;
        case 'network-request-failed':
          Utilities.showToast('Network error. Check your connection.');
          break;
        default:
          Utilities.showToast('Sign-in failed. Please try again.');
      }
      return null;
    } catch (e) {
      Utilities.showToast('Something went wrong. Please try again.');
      return null;
    }
  }

  static Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, RoutesManager.login);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          Utilities.showToast('Network error. Check your connection.');
          break;
        default:
          Utilities.showToast('Sign-out failed. Please try again.');
      }
    } catch (e) {
      Utilities.showToast('Sign-out failed. Please try again.');
    }
  }

  static Future<void> deleteAccount(BuildContext context) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    try {
      await userDocument.delete();
      await FirebaseAuth.instance.currentUser!.delete();
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, RoutesManager.login);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          Utilities.showToast('Network error. Check your connection.');
          break;
        default:
          Utilities.showToast('Account deletion failed. Please try again.');
      }
    } catch (e) {
      Utilities.showToast('Account deletion failed. Please try again.');
    }
  }
  static Future<void> updateProfile(BuildContext context) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
    _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    userDocument.update(UserModel.loggedInUser!.toJson());
    Navigator.pop(context);
  }
  static Future<void> addMovieToWishList(String movieId) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
    _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    UserModel.loggedInUser!.wishListMoviesIds!.add(movieId);
    userDocument.update(UserModel.loggedInUser!.toJson());
  }
  static Future<void> removeMovieFromWishList(String movieId) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
    _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    UserModel.loggedInUser!.wishListMoviesIds!.remove(movieId);
    userDocument.update(UserModel.loggedInUser!.toJson());
  }
}
