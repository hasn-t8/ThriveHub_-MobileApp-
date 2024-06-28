import 'package:flutter/material.dart';
import '../auth_screens/signup_screen.dart';
import '../auth_screens/signin_screen.dart';

class Welcome2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4), // Set the background color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image in the center
                Container(
                  width: 226.39,
                  height: 196.12,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/main.png'), // Make sure the path is correct
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Bold text below the image
                Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: 34, // Font size for 'Hello!'
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Normal text followed by bold text
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome to ',
                        style: TextStyle(
                          fontSize: 20, // Font size for the normal text
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Thrive Hub',
                        style: TextStyle(
                          fontSize: 20, // Font size for 'Thrive Hub'
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 70), // Add space between image and buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(
                  width: 335,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your onPressed code here!
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Reduced corner radius
                      ),
                      minimumSize: Size(335, 50), // Fixed width
                    ),
                    child: Text(
                      'Create account',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Add space between buttons
                SizedBox(
                  width: 335,
                  child: OutlinedButton(
                    onPressed: () {
                      // Add your onPressed code here!
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFD8DADC), width: 2), // Border color and width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Reduced corner radius
                      ),
                      minimumSize: Size(335, 50), // Fixed width
                    ),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.black, // Text color
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
