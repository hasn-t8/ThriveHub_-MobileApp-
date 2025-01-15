import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:convert'; // For decoding the token if necessary

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

    // Perform token and profile type check
    _checkAccessTokenAndNavigate();
  }

  Future<void> _checkAccessTokenAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final userTypes = prefs.getStringList('user_types') ?? [];

    // Simulate a delay for splash screen appearance
    await Future.delayed(Duration(seconds: 8));

    if (accessToken != null && accessToken.isNotEmpty) {
      // Example of token validation if required
      bool isTokenValid = true; // Replace with actual token validation logic

      if (isTokenValid) {
        // Check user type and navigate accordingly
        if (userTypes.contains('business-owner')) {
          Navigator.pushReplacementNamed(context, '/business-home'); // Replace with your business owner screen route
        } else if (userTypes.contains('registered-user')) {
          Navigator.pushReplacementNamed(context, '/dashboard'); // Replace with your registered user screen route
        } else {
          Navigator.pushReplacementNamed(context, '/welcome'); // Fallback if no valid user type
        }
        return;
      }
    }

    // If no valid token, navigate to the login screen
    Navigator.pushReplacementNamed(context, '/welcome');
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
              width: 250,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'), // Ensure the path is correct
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
