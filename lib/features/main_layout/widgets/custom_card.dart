import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/colors_manager.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsManager.darkGrey,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: child,
      ),
    );
  }
}
