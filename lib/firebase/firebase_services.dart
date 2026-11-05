import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/models/user_model.dart';

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

  static Future<bool> register(
    String name,
    String email,
    String password,
    String phoneNumber,
    String avatarName,
  ) async {
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
        rethrow;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          rethrow;
        case 'weak-password':
          rethrow;
        case 'invalid-email':
          rethrow;
        case 'network-request-failed':
          rethrow;
        default:
          rethrow;
      }
    } on FirebaseException  {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = await getCurrentUser(userCredential.user!.uid);
      if (user == null) {
        await FirebaseAuth.instance.signOut();
        throw ('No profile found');
      }
      UserModel.loggedInUser = user;
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
         rethrow;
        case 'user-not-found':
          rethrow;
        case 'wrong-password':
          rethrow;
        case 'user-disabled':
          rethrow;
        case 'too-many-requests':
          rethrow;
        case 'network-request-failed':
          rethrow;
        case 'invalid-email':
          rethrow;
        default:
          rethrow;
      }
    } on FirebaseException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential?> loginWithGoogle() async {
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
        throw ('No profile found');
      }
      UserModel.loggedInUser = user;

      return userCredential;
    } on GoogleSignInException catch (e) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
           rethrow;
           default:
          throw ("Google sign-in failed");
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          rethrow;
        case 'invalid-credential':
          rethrow;
        case 'user-disabled':
          rethrow;
        case 'network-request-failed':
          rethrow;
        default:
          rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential?> signUpWithGoogle(String phoneNumber) async {
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
          await GoogleSignIn.instance.signOut();
          rethrow;
        }

        UserModel.loggedInUser = user;
      } else {
        UserModel.loggedInUser = existing;
      }
      return userCredential;
    } on GoogleSignInException catch (e) {
      switch (e.code) {
        case GoogleSignInExceptionCode.canceled:
          rethrow;
        default:
          rethrow;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          rethrow;
        case 'invalid-credential':
          rethrow;
        case 'user-disabled':
          rethrow;
        case 'network-request-failed':
          rethrow;
        default:
          rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> signOut() async {
    try {
       await FirebaseAuth.instance.signOut();
       UserModel.loggedInUser = null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          rethrow;
        default:
          rethrow;
      }
    } catch (e) {
      rethrow;
    }
      try {
        await  GoogleSignIn.instance.signOut();
      } catch (e) {
        rethrow;
      }
      return true;

  }

  static Future<void> deleteAccount() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user found.',
      );
    }
    try {
      await firebaseUser.delete();
      final userId = firebaseUser.uid;
      final userDocument = _getUsersCollectionReference().doc(userId);
      await userDocument.delete();
      UserModel.loggedInUser = null;
      try {
        if(!isGoogleUser()) return;
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        rethrow;
      }
    } on FirebaseAuthException {
      rethrow;
    } on FirebaseException {
      rethrow;
    }
  }

  static Future<void> updateProfile({
    required String name,
    required String phone,
    required String avatarSeed,
  }) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
   try {
      await userDocument.update({
        'name': name,
        'phone': phone,
        'avatar': avatarSeed,
      }).timeout(const Duration(seconds: 10));
    } on FirebaseException  {
      rethrow;
   } catch (e) {
     rethrow;
   }

  }

  static Future<void> addMovieToWishList(Movie movie) async {
    final user = UserModel.loggedInUser;
    final currentList = user!.wishListMovies ?? [];
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    final updatedList = [...currentList, movie.toJson()];
    final exists = currentList.any(
          (item) => item['id'] == movie.id,
    );

    if (!exists) {
      await userDocument.update({'watchList': updatedList});
      user.wishListMovies = updatedList;
    } else {
      return;
    }
  }

  static Future<void> addMovieToHistory(Movie movie) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDox = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    final currentList = UserModel.loggedInUser!.watchedMovies ?? [];
    final updatedList = [...currentList, movie.toJson()];

    bool exists = UserModel.loggedInUser!.watchedMovies!.any(
      (item) => item['id'] == movie.id,
    );
    if (!exists) {
      await userDox.update({'history': updatedList});
      UserModel.loggedInUser!.watchedMovies = updatedList;
    }
  }

  static Future<void> removeMovieFromWishList(Movie movie) async {
    final user = UserModel.loggedInUser;
    final currentList = user!.wishListMovies ?? [];
    final updatedList = currentList
        .where((item) => item['id'] != movie.id)
        .toList();
    CollectionReference<Map<String, dynamic>> usersCollection =
        _getUsersCollectionReference();
    DocumentReference<Map<String, dynamic>> userDocument = usersCollection.doc(
      UserModel.loggedInUser!.id,
    );
    await userDocument.update({'watchList': updatedList});
    user.wishListMovies = updatedList;
  }

  static Future<bool> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw Exception('invalid-email');
        case 'user-not-found':
          throw Exception('user-not-found');
        case 'network-request-failed':
          throw Exception('network-request-failed');
        default:
          throw Exception('Password reset failed: ${e.code}');
      }
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  static bool isGoogleUser() {
    final user = FirebaseAuth.instance.currentUser;

    return user?.providerData.any(
          (info) => info.providerId == 'google.com',
    ) ?? false;
  }
}
