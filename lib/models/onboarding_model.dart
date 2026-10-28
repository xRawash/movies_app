import 'package:movies_app/core/sources/assets_manager.dart';

class OnboardingModel {
  String imageBath;
  String label;
  String description;

  OnboardingModel({
    required this.label,
    required this.description,
    required this.imageBath,
  });

  static List<OnboardingModel> onboarding = [
    OnboardingModel(
      label: "Find Your Next Favorite Movie Here",
      description: "Get access to a huge library of movies to suit all tastes. You will surely like it.",
      imageBath: ImageAssets.onboarding1,
    ),
    OnboardingModel(
      label: "Discover Movies",
      description: "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
      imageBath: ImageAssets.onboarding2,
    ),
    OnboardingModel(
      label: "Explore All Genres",
      description: "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
      imageBath: ImageAssets.onboarding3,
    ),
    OnboardingModel(
      label: "Create WatchLists",
      description: "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
      imageBath: ImageAssets.onboarding4,
    ),
    OnboardingModel(
      label: "Rate, Review, and Learn",
      description: "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
      imageBath: ImageAssets.onboarding5,
    ),
    OnboardingModel(
      label: "Start Watching Now",
      description: "",
      imageBath: ImageAssets.onboarding6,
    ),
  ];
}
