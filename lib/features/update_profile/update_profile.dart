import 'package:flutter/material.dart';
import 'package:movies_app/api/avatar_seeds/avatar_seeds.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_phone_field.dart';
import 'package:movies_app/core/widgets/custom_text_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/core/widgets/lang_switch.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/models/user_model.dart';
import 'package:movies_app/repos/update_profile_repo/update_profile_repo.dart';
import 'package:movies_app/view_models/update_profile_view_model/update_profile_view_model.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late TextEditingController _nameController;
  late PhoneController _phoneController;
  PhoneNumber? initialPhone;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    final user = UserModel.loggedInUser!;

    _nameController = TextEditingController(
      text: user.name ?? '',
    );

    PhoneNumber? parsedPhone;

    if (user.phone != null && user.phone!.isNotEmpty) {
      try {
        parsedPhone = PhoneNumber.parse(user.phone!);
      } catch (_) {
        parsedPhone = null;
      }
    }

    _phoneController = PhoneController(
      initialValue: parsedPhone ??
          PhoneNumber(isoCode: IsoCode.EG, nsn: ''),
    );
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
    return ChangeNotifierProvider(
      create: (_) =>
          UpdateProfileViewModel(updateProfileRepo: UpdateProfileRepo()),
      child: Consumer<UpdateProfileViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.updateProfile), centerTitle: true),
            body: SingleChildScrollView(
              child: Padding(
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
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ColorsManager.darkGrey,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                  ),
                              itemCount: AvatarSeeds.avatars.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  viewModel.changeAvatarSeed(AvatarSeeds.avatars[index]);
                                  Navigator.pop(context);
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
                                      "https://api.dicebear.com/7.x/avataaars/png?seed=${AvatarSeeds.avatars[index]}",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
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
                            viewModel.getAvatarLink(viewModel.avatarSeed),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
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
                        ],
                      ),
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
                          Text(
                            l10n.language,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Spacer(),
                          LangSwitch(),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: CustomTextButton(
                        title: Text(
                          l10n.resetPassword,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RoutesManager.forgetPassword,
                          );
                        },
                      ),
                    ),
                    Spacer(),
                    CustomElevatedButton(
                      title: Text(
                        l10n.deleteAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Delete account?'),
                            content: const Text(
                              'This action cannot be undone. Are you sure you want to delete your account?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext, true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete != true || !context.mounted) return;

                        final success = await viewModel.deleteAccount();

                        if (!context.mounted) return;

                        if (success) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesManager.login,
                                (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                viewModel.errorMessage ?? 'Account deletion failed.',
                              ),
                            ),
                          );
                        }
                      },
                      backgroundColor: ColorsManager.red,
                    ),
                    SizedBox(height: 19),
                    CustomElevatedButton(
                      title: Text(
                        l10n.updateAccount,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                        if (!_formKey.currentState!.validate()) return;
                        final success = await viewModel.updateAccount(
                          newName: _nameController.text.trim(),
                          newPhone: _phoneController.value.international,
                        );
              
                        if (!context.mounted) return;
              
                        if (success) {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                viewModel.errorMessage ?? 'Could not update profile',
                              ),
                            ),
                          );
                        }
                      },
                      backgroundColor: ColorsManager.yellow,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
