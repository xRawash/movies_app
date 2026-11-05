

abstract class UpdateProfileRepo {
  Future<void> updateAccount(
      {
    required String name,
    required String phone,
    required String avatarSeed,
  }) ;

  Future<void> deleteAccount();
}
