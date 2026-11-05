import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/repos/profile_repo/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  @override
  Future<bool> signOut() async {
    return await FirebaseServices.signOut();
  }
}