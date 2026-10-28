import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/features/auth/register_screen/register_screen.dart';

void main() {
  runApp(const Movies());
}

class Movies extends StatelessWidget {
  const Movies({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesManager.onboarding,
      onGenerateRoute: RoutesManager.getRoute,
      home: RegisterScreen(),
    );
  }
}

