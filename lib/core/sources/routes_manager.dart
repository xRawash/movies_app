import 'package:flutter/material.dart';
import 'package:movies_app/features/auth/register_screen/register_screen.dart';
import 'package:movies_app/onboarding/onboarding_screen.dart';

class RoutesManager {
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String forgetPassword = '/forgetPassword';
  static const String mainScreen = '/mainScreen';

  static Route? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding: {
        return MaterialPageRoute(builder: (context) => OnboardingScreen());
      }
      case register:
        {
          return MaterialPageRoute(builder: (context) => RegisterScreen());
        }
      default:
        {
          return null;
        }
    }
  }
}
