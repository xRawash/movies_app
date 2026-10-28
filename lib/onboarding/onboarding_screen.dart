import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
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
    return PageView.builder(
      itemCount: onboardings.length,
      controller: _pageController,
      itemBuilder: (context, index) {
        bool isFirstPage = index == 0;
        bool isLastPage = index == onboardings.length - 1;
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(onboardings[index].imageBath),
              fit: BoxFit.cover,
            ),
          ),
          child: BottomSheet(
            backgroundColor: index == 0
                ? Colors.transparent
                : ColorsManager.black,
            onClosing: () {},
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    Text(
                      onboardings[index].label,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      onboardings[index].description,
                      style: index == 0
                          ? Theme.of(context).textTheme.displayMedium
                          : Theme.of(context).textTheme.bodyMedium,
                    ),
                    CustomElevatedButton(
                      title: Text(
                        isFirstPage ? "Explore Now" : isLastPage ? "Finish" : "Next",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onPressed: () {
                        if (isLastPage){
                          PrefsManager.finishedOnboarding();
                          Navigator.pushReplacementNamed(context, '/register');
                        } else {
                          _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        }
                      },
                      backgroundColor: ColorsManager.yellow,
                    ),
                    index > 1
                        ? CustomElevatedButton(
                            title: Text(
                              "Back",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            onPressed: () {
                              _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                            },
                            backgroundColor: ColorsManager.black,
                      borderColor: ColorsManager.yellow,
                          )
                        : Container(),
                  ],
                ),
              );
            },
          ),
          // child: Container(
          //       decoration: BoxDecoration(
          //         color:index == 0 ? Colors.transparent : ColorsManager.black,
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(38),
          //           topRight: Radius.circular(38),
          //         ),
          //       ),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             onboardings[index].label,
          //             style: Theme.of(context).textTheme.labelLarge,
          //           ),
          //           SizedBox(height: 20),
          //           Text(
          //             onboardings[index].description,
          //             style: index == 0
          //                 ? Theme.of(context).textTheme.displayMedium
          //                 : Theme.of(context).textTheme.bodyMedium,
          //           ),
          //           SizedBox(height: 24),
          //           CustomElevatedButton(title: Text(index == 0 ? "Explore Now" : "Next", style: Theme.of(context).textTheme.titleMedium, ), onPressed: (){})
          //         ],
          //       ),
          //     )
        );
      },
    );
  }
}
