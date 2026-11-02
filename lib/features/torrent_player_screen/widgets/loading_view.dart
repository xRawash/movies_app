
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {

  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: Colors.white),
        const SizedBox(height: 24),
      ],
    );
  }
}