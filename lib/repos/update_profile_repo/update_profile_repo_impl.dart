import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/repos/update_profile_repo/update_profile_repo.dart';

class UpdateProfileRepoImpl implements UpdateProfileRepo {
  @override
  Future<void> updateAccount(
      {
        required String name,
        required String phone,
        required String avatarSeed,
      }) async {
    await FirebaseServices.updateProfile(
      name: name,
      phone: phone,
      avatarSeed: avatarSeed,
    );
  }
  @override
  Future<void> deleteAccount() async {
    await FirebaseServices.deleteAccount();
  }
}