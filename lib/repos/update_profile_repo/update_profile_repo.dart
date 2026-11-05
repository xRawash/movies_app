
import 'package:movies_app/firebase/firebase_services.dart';

abstract class UpdateProfileRepo {
  Future<void> updateAccount(
      {
    required String name,
    required String phone,
    required String avatarSeed,
  }) ;

  Future<void> deleteAccount();
}
