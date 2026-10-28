import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/core/widgets/lang_switch.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Image(image: AssetImage(ImageAssets.logo))),
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
            Align(
              alignment: Alignment.centerRight,
              child: CustomTextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesManager.forgetPassword);
                },
                title: Text(
                  "Forget Password ?",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            CustomElevatedButton(
              title: Text(
                "Login",
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
                Text("Don't Have Account ?"),
                CustomTextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesManager.register);
                  },
                  title: Text(
                    "Create One",
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
                    "Login With Google",
                    style: Theme.of(context).textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              onPressed: () {},
              backgroundColor: ColorsManager.yellow,
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
