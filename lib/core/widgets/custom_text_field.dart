import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/colors_manager.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validation,
    this.textInputType
  });

  final TextEditingController controller;
  final String hint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validation;
  final TextInputType? textInputType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscured;
  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
  }
  Widget obscureIcon(){
    return IconButton(
      onPressed: () {
        setState(() {
          isObscured = !isObscured;
        });
      },
      icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      obscuringCharacter: '*',
      style: TextStyle(fontSize: 16, color: Colors.white),
      validator: widget.validation,
      autovalidateMode: AutovalidateMode.always,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        suffixIcon: widget.obscureText ? obscureIcon() : widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        prefixIconColor: Colors.white,
        suffixIconColor: Colors.white,
        hintText: widget.hint,
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
    );
  }
}
