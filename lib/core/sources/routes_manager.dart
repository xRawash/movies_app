
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:movies_app/features/auth/forget_password/forget_password.dart';
import 'package:movies_app/features/auth/login_screen/login_screen.dart';
import 'package:movies_app/features/auth/register_screen/register_screen.dart';
import 'package:movies_app/features/main_layout/main_screen.dart';
import 'package:movies_app/features/main_layout/movies_by_genre/movies_by_genres.dart';
import 'package:movies_app/features/movie_details/movie_details.dart';
import 'package:movies_app/features/torrent_player_screen/torrent_player_screen.dart';
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
  static const String torrentPlayer = '/torrentPlayer';
  static const String moviesByGenre = '/moviesByGenre';

  static Route? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return _buildRoute(settings, OnboardingScreen());

      case register:
        return _buildRoute(settings, RegisterScreen());

      case login:
        return _buildRoute(settings, LoginScreen());

      case forgetPassword:
        return _buildRoute(settings, ForgetPassword());

      case mainScreen:
        return _buildRoute(settings, MainScreen());

      case updateProfile:
        return _buildRoute(settings, UpdateProfile());

      case movieDetails:
        return _buildRoute(settings, MovieDetails());

      case torrentPlayer:
        final args = settings.arguments as Map<String, dynamic>?;

        return _buildRoute(
          settings,
          TorrentPlayerScreen(
            magnetLink: args?['magnetLink'] ?? '',
            torrentId: args?['torrentId'] ?? '',
            movie: args!['movie'],
          ),
        );

      case moviesByGenre:
        final args = settings.arguments as Map<String, dynamic>?;

        return _buildRoute(
          settings,
          MoviesByGenres(
            genreId: args?['genreId'] ?? '',
          ),
        );

      default:
        return null;
    }
  }

  static PageTransition _buildRoute(
      RouteSettings settings,
      Widget page,
      ) {
    return PageTransition(
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 300),
      child: page,
      settings: settings,
    );
  }
}
