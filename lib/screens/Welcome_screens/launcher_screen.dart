import 'package:flutter/material.dart';

class LauncherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),  // Set the background color
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
                  image: AssetImage('assets/main.png'),  // Make sure the path is correct
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Bold text below the image
            Text(
              'Thrive Hub',
              style: TextStyle(
                fontSize: 28,  // Font size for 'Thrive Hub'
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Normal text below the bold text
            Text(
              'Explore. Feedback. Order.',
              style: TextStyle(
                fontSize: 16,  // Font size for the normal text
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
