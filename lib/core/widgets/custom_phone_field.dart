import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CustomPhoneField extends StatelessWidget {
  const CustomPhoneField({
    super.key,
    required this.controller,
    this.hint = "Phone Number",
    this.validator,
  });

  final PhoneController controller;
  final String hint;
  final String? Function(PhoneNumber?)? validator;

  @override
  Widget build(BuildContext context) {
    return PhoneFormField(
      controller: controller,
      style: TextStyle(fontSize: 16, color: Colors.white),
      countryCodeStyle: Theme.of(context).textTheme.displaySmall,
      countrySelectorNavigator: CountrySelectorNavigator.dialog(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.displaySmall,
        filled: true,
        fillColor: ColorsManager.darkGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: validator ??
          PhoneValidator.compose([
            PhoneValidator.required(context),
            PhoneValidator.valid(context),
          ]),
    );
  }
}
