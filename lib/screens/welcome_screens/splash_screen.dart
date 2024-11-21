import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool isThriveHubAnimationComplete = false;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController for the slide-in animation
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Start from left (outside the screen)
      end: Offset(0.0, 0.0), // End at its original position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start navigation after 5 seconds
    Future.delayed(Duration(seconds: 8), () {
      Navigator.pushReplacementNamed(context, '/welcome1');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4), // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image in the center
            Container(
              width: 226.39,
              height: 196.12,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/main.png'), // Ensure the path is correct
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Animated "Thrive Hub" text
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Thrive Hub',
                  textStyle: TextStyle(
                    fontSize: 28, // Font size
                    fontFamily: 'Inter', // Font family
                    fontWeight: FontWeight.w700, // Bold weight
                  ),
                  speed: Duration(milliseconds: 200), // Speed of animation
                ),
              ],
              isRepeatingAnimation: false, // Do not repeat the animation
              onFinished: () {
                // Trigger the slide-in animation for the normal text
                setState(() {
                  isThriveHubAnimationComplete = true;
                });
                _controller.forward();
              },
            ),
            SizedBox(height: 10),
            // Normal text animation
            if (isThriveHubAnimationComplete)
              SlideTransition(
                position: _offsetAnimation,
                child: Text(
                  'Explore. Feedback. Order.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
