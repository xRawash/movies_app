import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/models/onboarding_model.dart';
import 'package:movies_app/prefs_manager/prefs_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  List<OnboardingModel> onboardings = OnboardingModel.onboarding;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstPage = _currentIndex == 0;
    bool isLastPage = _currentIndex == onboardings.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardings.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                onboardings[index].imageBath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: _currentIndex == 0
                    ? Colors.transparent
                    : ColorsManager.black,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    onboardings[_currentIndex].label,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    onboardings[_currentIndex].description,
                    style: _currentIndex == 0
                        ? Theme.of(context).textTheme.displayMedium
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  CustomElevatedButton(
                    title: Text(
                      isFirstPage
                          ? "Explore Now"
                          : isLastPage
                              ? "Finish"
                              : "Next",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onPressed: () {
                      if (isLastPage) {
                        PrefsManager.finishedOnboarding();
                        Navigator.pushReplacementNamed(context, '/register');
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    backgroundColor: ColorsManager.yellow,
                  ),
                  if (_currentIndex > 1) ...[
                    const SizedBox(height: 12),
                    CustomElevatedButton(
                      title: Text(
                        "Back",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      backgroundColor: ColorsManager.black,
                      borderColor: ColorsManager.yellow,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
