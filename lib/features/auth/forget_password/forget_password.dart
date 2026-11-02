import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/validations/validations.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/firebase/firebase_services.dart';
import 'package:movies_app/l10n/app_localizations.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController _emailController;

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
      body: SingleChildScrollView(
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
                title: Text(
                  l10n.verifyEmail,
                  style: Theme.of(context).textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                onPressed: () {
                  FirebaseServices.resetPassword(_emailController.text.trim(), context);
                },
                backgroundColor: ColorsManager.yellow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
