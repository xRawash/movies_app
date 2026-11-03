import 'package:flutter/material.dart';
import 'package:movies_app/api/avatar_seeds/avatar_seeds.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_phone_field.dart';
import 'package:movies_app/core/widgets/custom_text_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/core/widgets/lang_switch.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/models/user_model.dart';
import 'package:phone_form_field/phone_form_field.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  UserModel currentUser = UserModel.loggedInUser!;
  late String avatarSeed;
  late TextEditingController _nameController;
  late PhoneController _phoneController;
  PhoneNumber? initialPhone;

  @override
  void initState() {
    super.initState();
    avatarSeed = currentUser.avatarName ?? " ";
    _nameController = TextEditingController(text: currentUser.name);
    if (currentUser.phone != null && currentUser.phone!.isNotEmpty) {
      try {
        initialPhone = PhoneNumber.parse(currentUser.phone!);
      } catch (e) {
        initialPhone = null;
      }
    }
    _phoneController = PhoneController(initialValue: initialPhone!);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(l10n.updateProfile), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorsManager.darkGrey,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: AvatarSeeds.avatars.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          setState(() {
                            avatarSeed = AvatarSeeds.avatars[index];
                            UserModel.loggedInUser!.avatarName = AvatarSeeds.avatars[index];
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: BoxBorder.all(
                              width: 3,
                              color: ColorsManager.yellow,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              'https://api.dicebear.com/7.x/avataaars/png?seed=${AvatarSeeds.avatars[index]}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.person,
                                color: ColorsManager.yellow,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 150,
                height: 150,
                child: CircleAvatar(
                  child: Image.network(
                    "https://api.dicebear.com/7.x/avataaars/png?seed=$avatarSeed",
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            CustomTextField(
              controller: _nameController,
              hint: "",
              prefixIcon: Icon(Icons.person),
            ),
            SizedBox(height: 20),
            CustomPhoneField(
              controller: _phoneController,
              hint: l10n.phone,
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorsManager.darkGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(l10n.language, style: Theme.of(context).textTheme.labelMedium,),
                  Spacer(),
                  LangSwitch(),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: CustomTextButton(
                title: Text(
                  l10n.resetPassword,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RoutesManager.forgetPassword);
                },
              ),
            ),
            Spacer(),
            CustomElevatedButton(
              title: Text(
                l10n.deleteAccount,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onPressed: () async {
                await FirebaseServices.deleteAccount(context);
              },
              backgroundColor: ColorsManager.red,
            ),
            SizedBox(height: 19),
            CustomElevatedButton(
              title: Text(
                l10n.updateAccount,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              onPressed: () async {
                UserModel.loggedInUser!.name = _nameController.text;
                UserModel.loggedInUser!.phone =
                    _phoneController.value.international;
                await FirebaseServices.updateProfile(context);
              },
              backgroundColor: ColorsManager.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
