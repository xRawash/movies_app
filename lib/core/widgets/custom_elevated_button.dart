import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
  });

  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
        padding: EdgeInsets.all(16),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
  }
}
