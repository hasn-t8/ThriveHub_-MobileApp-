import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/validators/email_validator.dart';
import 'package:thrive_hub/widgets/google_facbook_button.dart';
import 'signup_screen.dart';
import 'dart:convert';
import 'create_new_password.dart';
import 'forget_password.dart';
import 'verify_account.dart';
import '../../widgets/input_fields.dart';
import '../../services/auth_services/signin_service.dart'; // Import SignInService
import 'package:thrive_hub/widgets/bottom_navigation_bar.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscureText = true; // Variable to track whether password is visible or not
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false; // Variable to track loading state

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
    _printUserData(); // Call the method to print shared preferences data
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('user', userData['user'].toString());
    await prefs.setString('user', jsonEncode(userData['user']));
    await prefs.setString('access_token', userData['access_token']);
    await prefs.setString('expires_in', userData['expires_in']);
  }

  Future<void> _printUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user') ?? 'No user data';
    final accessToken = prefs.getString('access_token') ?? 'No access token';
    final expiresIn = prefs.getString('expires_in') ?? 'No expiry data';

    print('User data is : $user');
    print('Access Token data is : $accessToken');
    print('Expires In data is : $expiresIn');
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final validationError = emailValidator(email);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }
    if (_isButtonEnabled) {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      final signInService = SignInService();
      try {
        final response = await signInService.loginUser(
          email: _emailController.text,
          password: _passwordController.text,
        );
        print('Login successful, response: $response');

        // Save user data to shared preferences
        await _saveUserData(response);

        // Show a SnackBar with a gray background color
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login successful',
              style: TextStyle(color: Colors.black), // Text color black
            ),
            backgroundColor: Color(0xFFDADADA), // Gray background color
          ),
        );

        // Navigate to the main screen and remove all previous user_screens
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false, // Remove all previous routes
        );
      } catch (e) {
        print('Exception during login: $e');
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${e.toString().replaceAll('Exception: ', '')}'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Set loading state to false
        });
      }
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
              color: Color(0xFFF4F4F4),
              width: double.infinity,
              padding: const EdgeInsets.only(top: 70.0, bottom: 6.0,), // Adjusted padding
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the row
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Inter', // Set the font family to 'Inter'
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6), // Add some space between the image and the text
                        Image.asset(
                          'assets/star.png', // Replace with your image asset
                          width: 49,
                          height: 49,
                        ),
                      ],
                    ),
                    Text(
                      'We\'re excited to see you again. Log in to continue \nyour journey with us.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontFamily: 'Inter', // Set the font family to 'Inter'
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center, // Center the text
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // Form container
      Container(
        width: 375,
        height: 601,
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the form
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), // Rounded top-left corner
            topRight: Radius.circular(20), // Rounded top-right corner
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
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
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _obscureText
                            ? Color(0xFFACB5BB)
                            : Colors.black,
                      ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontFamily: 'Inter', // Set the font family to 'Inter'
                          fontWeight: FontWeight.w600,
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
                        backgroundColor: _isButtonEnabled ? Color(0XFF313131) : Color(0xFFC3C1C1), // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Reduced corner radius
                        ),
                        minimumSize: Size(double.infinity, 48), // Fixed height
                      ),
                      child: _isLoading // Show loading indicator if _isLoading is true
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white, // Text color remains white
                          fontSize: 16,
                          fontFamily: 'Inter', // Set the font family to 'Inter'
                          fontWeight: FontWeight.w600,
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
                            fontSize: 12,
                            fontFamily: 'Inter', // Set the font family to 'Inter'
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.7), // Black with 70% opacity
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
                      SocialMediaButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        image: AssetImage('assets/google.png'),
                        label: 'Continue with Google',
                      ),
                      SizedBox(height: 10),
                      SocialMediaButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        image: AssetImage('assets/facebook.png'),
                        label: 'Continue with Facebook',
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
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.7), // Black with 70% opacity
                            fontFamily: 'SF Pro Display', // Set the font family to 'SF Pro Display'
                            fontWeight: FontWeight.w400, // Set font weight to 400
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Add your onTap code here!
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black, // Black with 70% opacity
                              fontFamily: 'SF Pro Display', // Set the font family to 'SF Pro Display'
                              fontWeight: FontWeight.w500, // Set font weight to 500
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
           ),
          ],
        ),
      ),
    );
  }
}
