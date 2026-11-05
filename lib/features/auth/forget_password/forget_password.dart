import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/core/validations/validations.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/repos/auth_repo/auth_repo_impl.dart';
import 'package:movies_app/view_models/auth_view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(l10n.forgetPassword)),
      body: ChangeNotifierProvider(
        create: (_) => AuthViewModel(authRepo: AuthRepoImpl()),
        child: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) => SingleChildScrollView(
            child: Form(
              key: _formKey ,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image(image: AssetImage(ImageAssets.forgetPassword)),
                    SizedBox(height: 24),
                    CustomTextField(
                      controller: _emailController,
                      validation: Validations.validateEmail,
                      hint: l10n.email,
                      prefixIcon: Icon(Icons.email),
                    ),
                    SizedBox(height: 40),
                    CustomElevatedButton(
                      title: viewModel.isLoading ? CircularProgressIndicator() : Text(
                        l10n.verifyEmail,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                      onPressed: viewModel.isLoading? null : () async {
                        if(_formKey.currentState!.validate() == false) return;
                        bool succeeded = await viewModel.resetPassword(_emailController.text.trim(),);
                        if (viewModel.errorMessage != null) {
                          Utilities.showToast(viewModel.errorMessage!);
                        }
                        if(succeeded) {
                          if (!context.mounted) return;
                          Utilities.showToast("Email sent successfully");
                          Navigator.pop(context);
                        }
                      },
                      backgroundColor: ColorsManager.yellow,
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
