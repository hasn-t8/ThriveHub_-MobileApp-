import 'package:flutter/material.dart';
import 'package:thrive_hub/business_screens/widgets/business_bottom_navigation_bar.dart';
import 'business_signup_screen.dart';
import '../../widgets/input_fields.dart';
import '../slider_screens/business_category_screen.dart';
import '../slider_screens/business_slider_screen.dart';

class BusinessSignInScreen extends StatefulWidget {
  const BusinessSignInScreen({super.key});

  @override
_BusinessSignInScreenState createState() => _BusinessSignInScreenState();
}

class _BusinessSignInScreenState extends State<BusinessSignInScreen> {
  bool _obscureText = true; // Variable to track whether password is visible or not
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonEnabled = false;

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Simulate a login action
    if (_isButtonEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SliderScreen()),
        //remove this
        // MaterialPageRoute(builder: (context) => MainScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful'),
        ),
      );
      // Navigate to the main screen or perform other actions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4), // Set the background color
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top section with the first background color and heading
            Container(
              color: Color(0xFFD8DADC),
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80.0, bottom: 6.0,), // Adjusted padding
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the row
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10), // Add some space between the image and the text
                        Image.asset(
                          'assets/star.png', // Replace with your image asset
                          width: 49,
                          height: 49,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'We\'re excited to see you again. Log in to continue \nyour journey with us.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center, // Center the text
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Form container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email field
                  CustomInputField(
                    labelText: 'Email',
                    controller: _emailController,
                  ),
                  SizedBox(height: 12),
                  // Password field
                  CustomInputField(
                    labelText: 'Password',
                    controller: _passwordController,
                    obscureText: _obscureText,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText; // Toggle the _obscureText variable
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  // Forget password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Add your onTap code here!
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? _login : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonEnabled ? Color(0xFF828282) : Color(0xFFC3C1C1), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Reduced corner radius
                        ),
                        minimumSize: Size(double.infinity, 50), // Fixed height
                      ),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white, // Text color remains white
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFD9D9D9),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or Log in with',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFD9D9D9),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // "Continue with" buttons vertically
                  Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        icon: Icon(Icons.g_translate),
                        label: Text(
                          'Continue with Google',
                          style: TextStyle(color: Colors.black), // Set text color to black
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFD8DADC), width: 3), // Border color and width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Reduced corner radius
                          ),
                          minimumSize: Size(double.infinity, 50), // Fixed width and height
                        ),
                      ),
                      SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        icon: Icon(Icons.facebook),
                        label: Text(
                          'Continue with Facebook',
                          style: TextStyle(color: Colors.black), // Set text color to black
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFD8DADC), width: 3), // Border color and width
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Reduced corner radius
                          ),
                          minimumSize: Size(double.infinity, 50), // Fixed width and height
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                  // "Don't have an account" row
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add your onTap code here!
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BusinessSignUpScreen()),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
