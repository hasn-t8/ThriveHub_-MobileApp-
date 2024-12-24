//imports
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thrive_hub/core/utils/email_validator.dart';
import '../../../core/constants/text_styles.dart';
import 'sign_in.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/google_facbook_button.dart';
import '../../../widgets/forms/social_login.dart';
import '../../../widgets/headers/custom_header_1.dart';
import '../../../services/auth_services/auth_service.dart';

class BusinessSignUpScreen extends StatefulWidget {
  @override
  _BusinessSignUpScreenState createState() => _BusinessSignUpScreenState();
}

class _BusinessSignUpScreenState extends State<BusinessSignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  void _validateEmail() {
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
    _registerUser();
  }

  Future<void> _registerUser() async {
    final companyName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (companyName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields must be filled correctly')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters long')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start the loader
    });

    try {
      final responseData = await AuthService().registerUser(
        companyName: companyName,
        email: email,
        password: password,
        userTypes: ['business-owner'], // Passing the list here
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully',
            style: TextStyle(color: Colors.black), // Text color black
          ),
          backgroundColor: Color(0xFFDADADA), // Gray background color
        ),
      );

      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   '/business-profile-setup',
      //       (Route<dynamic> route) => false,  // This removes all previous routes
      // );

    } catch (e) {
      print(e);
      String errorMessage = e.toString().replaceAll('Exception:', '').trim();

      // Extract and handle errors if available
      try {
        final responseData = jsonDecode(e.toString()) as Map<String, dynamic>;
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final firstErrorKey = errors.keys.first;
          final firstErrorMessage = errors[firstErrorKey].values.first;
          errorMessage = firstErrorMessage;
        } else {
          errorMessage = responseData['message'] ?? errorMessage;
        }
      } catch (_) {
        // Ignore JSON decode errors and use the original error message
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop the loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final passwordsMatch =
        _passwordController.text == _confirmPasswordController.text;
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: kDividerColor, // Use constant for divider color
              width: double.infinity,
              child: const Center(
                child: Column(
                  children: [
                    CustomHeaderTh(
                      headingText: 'Get Start Now',
                      headingImagePath: 'assets/star.png',
                    ),
                  ],
                ),
              ),
            ),
        Container(
          width: MediaQuery.of(context).size.width, // Full screen width
          height: MediaQuery.of(context).size.height, // Full screen height
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the form
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(20), // Rounded top-left corner
            //   topRight: Radius.circular(20), // Rounded top-right corner
            // ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField(
                    labelText: 'Company Name',
                    controller: _nameController,
                  ),
                  SizedBox(height: 12),
                  CustomInputField(
                    labelText: 'Email',
                    controller: _emailController,
                  ),
                  SizedBox(height: 12),
                  CustomInputField(
                    labelText: 'Password',
                    hintText:
                    'Create Password', // Pass custom hint text here
                    controller: _passwordController,
                    obscureText: _obscureText1,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText1
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _obscureText1
                            ? Color(0xFFACB5BB)
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText1 = !_obscureText1;
                        });
                      },
                    ),
                    borderColor: passwordsMatch
                        ? Color(0xFFEDF1F3)
                        : Color(0xFF0C9809), // Dynamic border color
                  ),

                  SizedBox(height: 12),
                  CustomInputField(
                    labelText: 'Confirm Password',
                    hintText:
                    'Repeat your password', // Pass custom hint text here
                    controller: _confirmPasswordController,
                    obscureText: _obscureText2,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText2
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _obscureText2
                            ? Color(0xFFACB5BB)
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText2 = !_obscureText2;
                        });
                      },
                    ),
                    borderColor: passwordsMatch
                        ? Color(0xFFEDF1F3)
                        : Color(0xFF0C9809), // Dynamic border color
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ElevatedButton(
                          onPressed: _isButtonEnabled && !_isLoading ? _validateEmail : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF828282), // Change the color to #828282
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (_isLoading)
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFD9D9D9),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or Register with',
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
                  SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                              Navigator.pushNamed(context, '/business-sign-in');
                          },
                          child: const Text(
                            'Login',
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
        ),
          ],
        ),
      ),
    );
  }
}
