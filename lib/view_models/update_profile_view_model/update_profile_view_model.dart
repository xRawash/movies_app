import 'package:flutter/cupertino.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/models/user_model.dart';
import 'package:movies_app/repos/update_profile_repo/update_profile_repo.dart';
import 'package:phone_form_field/phone_form_field.dart';

class UpdateProfileViewModel extends ChangeNotifier {
  final UpdateProfileRepo _updateProfileRepo;

  UpdateProfileViewModel({required this._updateProfileRepo});

  UserModel currentUser = UserModel.loggedInUser!;
  String? avatarSeed = UserModel.loggedInUser!.avatarName;
  PhoneNumber? initialPhone;
  bool isLoading = false;
  String? errorMessage;

  Future<void> updateAccount(BuildContext context, String newName, String newPhone) async {
    AppLocalizations l10n = AppLocalizations.of(context)!;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    UserModel.loggedInUser!.name = newName;
    UserModel.loggedInUser!.phone = newPhone;
   try {
     await _updateProfileRepo.updateAccount(context);
   } catch (e) {
     errorMessage = e.toString();
     Utilities.showToast(l10n.somethingWentWrong);
   } finally {
     isLoading = false;
     notifyListeners();
   }


  }

  Future<void> deleteAccount(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    {
      try {
        await _updateProfileRepo.deleteAccount(context);
      } on Exception catch (e) {
        errorMessage = e.toString();
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }
  void init() {
    avatarSeed = currentUser.avatarName;
    if (currentUser.phone != null && currentUser.phone!.isNotEmpty) {
      try {
        initialPhone = PhoneNumber.parse(currentUser.phone!);
      } catch (e) {
        initialPhone = null;
      }
    }
  }
  void changeAvatarSeed(String seed) {
    UserModel.loggedInUser!.avatarName = seed;
    notifyListeners();
  }
  String? getAvatarLink(String seed) {
    String avatarLink = 'https://api.dicebear.com/7.x/avataaars/png?seed=$seed';
    return avatarLink;
  }
}
