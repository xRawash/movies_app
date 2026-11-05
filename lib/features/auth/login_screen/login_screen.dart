import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/core/validations/validations.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/core/widgets/lang_switch.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/repos/auth_repo/auth_repo_impl.dart';
import 'package:movies_app/view_models/auth_view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool isArabic = false;
  bool isObscured = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: ChangeNotifierProvider(
        create:(_) => AuthViewModel(authRepo: AuthRepoImpl()),
        child: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) =>
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: Image(image: AssetImage(ImageAssets.logo))),
                    CustomTextField(
                      controller: _emailController,
                      validation: Validations.validateEmail,
                      hint: l10n.email,
                      prefixIcon: Icon(Icons.email),
                    ),
                    SizedBox(height: 23),
                    CustomTextField(
                      controller: _passwordController,
                      validation: Validations.validatePassword,
                      obscureText: isObscured,
                      hint: l10n.password,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                        icon: Icon(
                          isObscured ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomTextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesManager.forgetPassword);
                        },
                        title: Text(
                          l10n.forgetPassword,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ),
                    CustomElevatedButton(
                      title: Text(
                        l10n.login,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                      onPressed: () async  {
                        await viewModel.login(_emailController.text.trim(), _passwordController.text.trim(), context, _formKey);
                        if (!context.mounted) return;
                        if (viewModel.isLoading) {
                          Utilities.showLoadingDialog(context);
                        }
                        if (viewModel.errorMessage != null) {
                          Utilities.showToast(viewModel.errorMessage!);
                        }
                      },
                      backgroundColor: ColorsManager.yellow,
                    ),
                    SizedBox(height: 23),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.dontHaveAccount),
                        CustomTextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RoutesManager.register);
                          },
                          title: Text(
                            l10n.createOne,
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            indent: 40,
                            color: ColorsManager.yellow,
                            thickness: 1,
                            height: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "OR",
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(fontSize: 15),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            endIndent: 40,
                            color: ColorsManager.yellow,
                            thickness: 1,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    CustomElevatedButton(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageIcon(
                            AssetImage(ImageAssets.googleLogo),
                            color: ColorsManager.black,
                          ),
                          SizedBox(width: 8),
                          Text(
                            l10n.loginWithGoogle,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      onPressed: () async  {
                        await viewModel.loginWithGoogle(context);
                        if (!context.mounted) return;
                        if (viewModel.isLoading) {
                          Utilities.showLoadingDialog(context);
                        }
                        if (viewModel.errorMessage != null) {
                          Utilities.showToast(viewModel.errorMessage!);
                        }
                      },
                      backgroundColor: ColorsManager.yellow,
                    ),
                    SizedBox(height: 16),
                    Center(
                        child: LangSwitch()
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
