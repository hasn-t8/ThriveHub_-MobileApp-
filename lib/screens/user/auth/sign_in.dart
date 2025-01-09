import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/core/utils/email_validator.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_slider_screen.dart';
import 'package:thrive_hub/screens/user/auth/activate_account.dart';
import 'package:thrive_hub/screens/welcome_screens/main_screen.dart';
import 'package:thrive_hub/services/auth_services/auth_service.dart';
import 'package:thrive_hub/widgets/google_facbook_button.dart';
import 'sign_up.dart';
import 'dart:convert';
import 'create_new_password.dart';
import 'forget_password.dart';
import 'verify_account.dart';
import '../../../widgets/input_fields.dart';
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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  Future<void> _saveUserData(Map<String, dynamic> responseData) async {
    final prefs = await SharedPreferences.getInstance();

// Capitalize the first letter of full name if it's not empty
    String fullName = (responseData['user']['full_name'] ?? '').isNotEmpty
        ? responseData['user']['full_name'][0].toUpperCase() + responseData['user']['full_name'].substring(1).toLowerCase()
        : '';
    // Save the access token
    await prefs.setString('access_token', responseData['token']);

    // Save other user data
    await prefs.setString('full_name', fullName);
    await prefs.setString('email', responseData['user']['email'] ?? '');
    await prefs.setStringList('user_types', List<String>.from(responseData['user']['userTypes']));
    await prefs.setString('profile_image', responseData['user']['profileImage'] ?? '');
    await prefs.setString('city', responseData['user']['city'] ?? 'city');

    // Optionally, print the saved data to verify
    print('User Data saved:');
    print('Full Name: ${responseData['user']['full_name']}');
    print('Email: ${responseData['user']['email']}');
    print('User Types: ${responseData['user']['userTypes']}');
    print('Profile Image: ${responseData['user']['profileImage']}');
    print('City: ${responseData['user']['city']}');

    // Retrieve and print the access token to confirm it's saved correctly
    final accessToken = prefs.getString('access_token') ?? 'No access token';
    print('Access Token: $accessToken');
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

      final signInService = AuthService();
      try {
        final response = await signInService.loginUser(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (response != null && response.containsKey('token')) {
          await _saveUserData(response);

          // Check the user type and navigate accordingly
          List<String> userTypes = List<String>.from(response['user']['userTypes']);
          if (userTypes.contains('business-owner')) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BusinessSliderScreen()),
                  (Route<dynamic> route) => false,
            );
          } else if (userTypes.contains('registered-user')) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Unknown user type'),
              ),
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login successful'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Unexpected response format');
        }
      } catch (e) {
        if (e.toString().contains('403')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivateAccountScreen(email: email),
            ),
          );
        } else {
          print('Exception during login: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${e.toString().replaceAll('Exception: ', '')}'),
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
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
        width: MediaQuery.of(context).size.width, // Full screen width
        height: MediaQuery.of(context).size.height, // Full screen height
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
                  SizedBox(height: 65),
                  // "Don't have an account" row
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
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
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black, // Black
                                  fontFamily: 'SF Pro Display', // Set the font family to 'SF Pro Display'
                                  fontWeight: FontWeight.w500, // Set font weight to 500
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6), // Add some spacing between the rows
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigate to the slider screen and remove all previous routes
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => SliderScreen()),
                                      (Route<dynamic> route) => false, // This condition removes all previous routes
                                );
                              },

                              child: Text(
                                'Go to Main Menu',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue, // Blue text for distinction
                                  fontFamily: 'SF Pro Display', // Set the font family to 'SF Pro Display'
                                  fontWeight: FontWeight.w500, // Set font weight to 500
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
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
