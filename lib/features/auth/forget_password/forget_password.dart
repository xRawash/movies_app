import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/validations/validations.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text("Forget Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image(image: AssetImage(ImageAssets.forgerPassword)),
            SizedBox(height: 24),
            CustomTextField(
              controller: _emailController,
              validation: Validations.validateEmail,
              hint: "Email",
              prefixIcon: Icon(Icons.email),
            ),
            SizedBox(height: 24),
            CustomElevatedButton(
              title: Text(
                "Verify Email",
                style: Theme.of(context).textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              onPressed: () {},
              backgroundColor: ColorsManager.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
