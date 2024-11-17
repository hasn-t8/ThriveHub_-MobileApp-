import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'first_screen.dart';
import 'welcome_one.dart';
import 'welcome_two.dart';

class SliderScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              LauncherScreen(),
              Welcome1Screen(),
              Welcome2Screen(),
            ],
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,

                effect: WormEffect(),  // Customize the effect as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
