import 'package:flutter/material.dart';
import 'package:movies_app/api/avatar_seeds/avatar_seeds.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/core/validations/password_criteria_validations.dart';
import 'package:movies_app/core/validations/validations.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_phone_field.dart';
import 'package:movies_app/core/widgets/custom_text_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/core/widgets/lang_switch.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/repos/auth_repo/auth_repo_impl.dart';
import 'package:movies_app/view_models/auth_view_model/auth_view_model.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late PhoneController _phoneNumberController;
  late TextEditingController _passwordConfirmController;
  late PageController _pageController;
  bool isArabic = false;
  bool isObscured = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final FocusNode _passwordFocusNode;
  final ValueNotifier<bool> _showPasswordCriteria = ValueNotifier<bool>(false);
  final ValueNotifier<String> _passwordText = ValueNotifier<String>('');

  final List<String> avatarSeeds = AvatarSeeds.avatars;
  late String selectedAvatarSeed;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _phoneNumberController = PhoneController();
    _passwordConfirmController = TextEditingController();
    _pageController = PageController(viewportFraction: 0.35, initialPage: 0);
    selectedAvatarSeed = avatarSeeds[0];
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener((){
      _showPasswordCriteria.value = _passwordFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordConfirmController.dispose();
    _pageController.dispose();
    _passwordFocusNode.dispose();
    _showPasswordCriteria.dispose();
    _passwordText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.register)),
      body: ChangeNotifierProvider(
        create: (_) => AuthViewModel(authRepo: AuthRepoImpl()),
        child: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) => Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 90,
                    child: PageView.builder(
                      controller: _pageController,
                      physics: BouncingScrollPhysics(),
                      itemCount: avatarSeeds.length,
                      onPageChanged: (index) {
                        setState(() {
                          selectedAvatarSeed = avatarSeeds[index];
                        });
                      },
                      itemBuilder: (context, index) {
                        final seed = avatarSeeds[index];
                        final isSelected = seed == selectedAvatarSeed;
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 1.0;
                            if (_pageController.position.haveDimensions) {
                              value = _pageController.page! - index;
                              value = (1 - (value.abs() * 0.25)).clamp(
                                0.75,
                                1.0,
                              );
                            }
                            return Center(
                              child: Transform.scale(
                                scale: value,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? ColorsManager.yellow
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: ColorsManager.yellow.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://api.dicebear.com/7.x/avataaars/png?seed=$seed',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.person,
                                      color: ColorsManager.yellow,
                                      size: 36,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Swipe to choose your avatar",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall
                        ?.copyWith(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _nameController,
                    validation: Validations.validateName,
                    hint: l10n.name,
                    prefixIcon: Icon(Icons.perm_identity_outlined),
                  ),
                  SizedBox(height: 23),
                  CustomTextField(
                    controller: _emailController,
                    validation: Validations.validateEmail,
                    hint: l10n.email,
                    prefixIcon: Icon(Icons.email),
                  ),
                  SizedBox(height: 23),
                  ValueListenableBuilder<bool>(
                    valueListenable: _showPasswordCriteria,
                    builder: (context, showCriteria, child) {
                      return ValueListenableBuilder<String>(
                        valueListenable: _passwordText,
                        builder: (context, password, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                validation: Validations.validatePassword,
                                obscureText: isObscured,
                                hint: l10n.password,
                                prefixIcon: const Icon(Icons.lock),
                                onChanged: (value) {
                                  _passwordText.value = value;
                                },
                              ),

                              if (showCriteria) ...[
                                const SizedBox(height: 12),
                                _buildPasswordCriteria(password),
                              ],
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordConfirmController,
                    validation: (value) =>
                        Validations.validatePasswordConfirmation(
                          value,
                          _passwordController.text,
                        ),
                    obscureText: isObscured,
                    hint: l10n.confirmPassword,
                    prefixIcon: Icon(Icons.lock),
                  ),
                  SizedBox(height: 16),
                  CustomPhoneField(controller: _phoneNumberController),
                  SizedBox(height: 16),
                  CustomElevatedButton(
                    title: viewModel.isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            l10n.createAccount,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate() == false) {
                              return;
                            }
                            final phoneStr =
                                _phoneNumberController.value.international;
                            bool succeeded = await viewModel.register(
                              _nameController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              phoneStr,
                              selectedAvatarSeed,
                            );
                            if (viewModel.errorMessage != null) {
                              Utilities.showToast(viewModel.errorMessage!);
                            }
                            if (!context.mounted) return;
                            if (succeeded) {
                              Utilities.showToast(l10n.accountCreatedSuccessfully);
                              Navigator.pushReplacementNamed(
                                context,
                                RoutesManager.login,
                              );
                            }
                          },
                    backgroundColor: ColorsManager.yellow,
                  ),
                  SizedBox(height: 23),
                  CustomElevatedButton(
                    title: viewModel.isLoading
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageIcon(
                                AssetImage(ImageAssets.googleLogo),
                                color: ColorsManager.black,
                              ),
                              SizedBox(width: 8),
                              Text(
                                l10n.signUpWithGoogle,
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            final phoneStr =
                                _phoneNumberController.value.international;
                            if (phoneStr.isEmpty) {
                              Utilities.showToast(l10n.invalidPhoneNumber);
                              return;
                            }
                          final userCred = await viewModel.signUpWithGoogle(phoneStr);
                            if (viewModel.errorMessage != null) {
                              Utilities.showToast(viewModel.errorMessage!);
                            }
                            if (userCred != null) {
                              if(!context.mounted) return;
                              Utilities.showToast("Welcome ${userCred.user!.displayName}");
                              Navigator.pushReplacementNamed(context, RoutesManager.mainScreen);
                            }
                          },
                    backgroundColor: ColorsManager.yellow,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.alreadyHaveAccount),
                      CustomTextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            RoutesManager.login,
                          );
                        },
                        title: Text(
                          l10n.login,
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Center(child: LangSwitch()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildPasswordCriteria(String password) {
    final criteria = {
      'At least 8 characters':
      PasswordCriteriaValidations.hasMinLength(password),
      'One uppercase letter (A-Z)':
      PasswordCriteriaValidations.hasUppercase(password),
      'One lowercase letter (a-z)':
      PasswordCriteriaValidations.hasLowercase(password),
      'At least one number (0-9)':
      PasswordCriteriaValidations.hasNumber(password),
      'One special character (!@#\$&*~)':
      PasswordCriteriaValidations.hasSpecialCharacter(password),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: criteria.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            children: [
              Icon(
                entry.value
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                size: 17,
                color: entry.value
                    ? Colors.green
                    : Colors.white54,
              ),
              const SizedBox(width: 8),
              Text(
                entry.key,
                style: TextStyle(
                  color: entry.value
                      ? Colors.green
                      : Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
