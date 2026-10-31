import 'package:flutter/material.dart';
import 'package:movies_app/api/avatar_seeds/avatar_seeds.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/core/utilities/utilities.dart';
import 'package:movies_app/core/validations/validations.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/core/widgets/lang_switch.dart';
import 'package:movies_app/firebase/firebase_services.dart';

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
  late PageController _pageController;
  bool isArabic = false;
  bool isObscured = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> avatarSeeds = AvatarSeeds.avatars;
  late String selectedAvatarSeed;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _pageController = PageController(viewportFraction: 0.35, initialPage: 0);
    selectedAvatarSeed = avatarSeeds[0];
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordConfirmController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Form(
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
                          value = (1 - (value.abs() * 0.25)).clamp(0.75, 1.0);
                        }
                        return Center(
                          child: Transform.scale(scale: value, child: child),
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
                            errorBuilder: (context, error, stackTrace) => Icon(
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
                hint: "Name",
                prefixIcon: Icon(Icons.perm_identity_outlined),
              ),
              SizedBox(height: 23),
              CustomTextField(
                controller: _emailController,

                validation: Validations.validateEmail,
                hint: "Email",
                prefixIcon: Icon(Icons.email),
              ),
              SizedBox(height: 23),
              CustomTextField(
                controller: _passwordController,
                validation: Validations.validatePassword,
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
                validation: (value) => Validations.validatePasswordConfirmation(
                  value,
                  _passwordController.text,
                ),
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
                validation: Validations.validatePhone,
                textInputType: TextInputType.phone,
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
                onPressed: () {
                  FirebaseServices.register(
                    _nameController.text.trim(),
                    _emailController.text.trim(),
                    _passwordController.text,
                    _phoneNumberController.text,
                    context,
                    selectedAvatarSeed,
                    _formKey,
                  );
                },
                backgroundColor: ColorsManager.yellow,
              ),
              SizedBox(height: 23),
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
                      "SignUp With Google",
                      style: Theme.of(context).textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                onPressed: () {
                  final phoneError = Validations.validatePhone(_phoneNumberController.text.trim());
                  if(phoneError != null){
                    Utilities.showToast('Invalid Phone Number');
                    return;
                  }
                  FirebaseServices.signUpWithGoogle(_phoneNumberController.text.trim(),context);
                },
                backgroundColor: ColorsManager.yellow,
              ),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Have Account ?"),
                  CustomTextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutesManager.login,
                      );
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
              Center(child: LangSwitch()),
            ],
          ),
        ),
      ),
    );
  }
}
