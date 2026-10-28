import 'package:flutter/material.dart';
import 'package:movies_app/config/theme_manager.dart';
import 'package:movies_app/core/sources/routes_manager.dart';
import 'package:movies_app/features/auth/register_screen/register_screen.dart';
import 'package:movies_app/prefs_manager/prefs_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsManager.init();
  runApp(const Movies());
}

class Movies extends StatelessWidget {
  const Movies({super.key});

  @override
  Widget build(BuildContext context) {
    bool isFinishedOnboarding = PrefsManager.getIsFinishedOnboarding() ?? false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isFinishedOnboarding ? RoutesManager.register : RoutesManager.onboarding,
      onGenerateRoute: RoutesManager.getRoute,
      theme: ThemeManager.light,
    );
  }
}

