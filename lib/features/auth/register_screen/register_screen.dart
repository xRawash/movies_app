import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/core/widgets/lang_switch.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordConfirmController;
  bool isArabic = false;
  bool isObscured = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _nameController,
              hint: "Name",
              prefixIcon: Icon(Icons.perm_identity_outlined),
            ),
            SizedBox(height: 23),
            CustomTextField(
              controller: _emailController,
              hint: "Email",
              prefixIcon: Icon(Icons.email),
            ),
            SizedBox(height: 23),
            CustomTextField(
              controller: _passwordController,
              obscureText: isObscured,
              hint: "Password",
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
            CustomTextField(
              controller: _passwordConfirmController,
              obscureText: isObscured,
              hint: "Confirm Password",
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
            CustomTextField(
              controller: _phoneNumberController,
              hint: "Phone Number",
              prefixIcon: Icon(Icons.phone),
            ),
            SizedBox(height: 16),
            CustomElevatedButton(
              title: Text(
                "Create Account",
                style: Theme.of(context).textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              onPressed: () {},
              backgroundColor: ColorsManager.yellow,
            ),
            SizedBox(height: 23),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already Have Account ?"),
                CustomTextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RoutesManager.login);
                  },
                  title: Text(
                    "Login",
                    style: Theme.of(context).textTheme.labelSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
                child: LangSwitch()
            ),
          ],
        ),
      ),
    );
  }
}
