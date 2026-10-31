import 'package:flutter/material.dart';
import 'package:movies_app/features/auth/forget_password/forget_password.dart';
import 'package:movies_app/features/auth/login_screen/login_screen.dart';
import 'package:movies_app/features/auth/register_screen/register_screen.dart';
import 'package:movies_app/features/main_layout/main_screen.dart';
import 'package:movies_app/features/movie_details/movie_details.dart';
import 'package:movies_app/features/update_profile/update_profile.dart';
import 'package:movies_app/onboarding/onboarding_screen.dart';

class RoutesManager {
  static const String onboarding = '/onboarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String forgetPassword = '/forgetPassword';
  static const String mainScreen = '/mainScreen';
  static const String updateProfile = '/updateProfile';
  static const String movieDetails = '/movieDetails';

  static Route? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        {
          return MaterialPageRoute(builder: (context) => OnboardingScreen());
        }
      case register:
        {
          return MaterialPageRoute(builder: (context) => RegisterScreen());
        }
      case login:
        {
          return MaterialPageRoute(builder: (context) => LoginScreen());
        }
      case forgetPassword:
        {
          return MaterialPageRoute(builder: (context) => ForgetPassword());
        }
      case mainScreen:
        {
          return MaterialPageRoute(builder: (context) => MainScreen());
        }
      case updateProfile:
        {
          return MaterialPageRoute(builder: ((context) => UpdateProfile()));
        }
      case movieDetails:
        {
          return MaterialPageRoute(
            builder: (context) => MovieDetails(),
            settings: settings,
          );
        }
      default:
        {
          return null;
        }
    }
  }
}
