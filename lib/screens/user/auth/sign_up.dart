import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/core/utils/email_validator.dart';
import 'package:thrive_hub/screens/user/auth/activate_account.dart';
import 'package:thrive_hub/screens/welcome_screens/main_screen.dart';
import 'sign_in.dart';
import '../../../widgets/input_fields.dart';
import '../../../widgets/google_facbook_button.dart';
import '../../../services/auth_services/auth_service.dart';
import 'package:thrive_hub/widgets/bottom_navigation_bar.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isButtonEnabled = false;
  bool _isLoading = false; // Variable to track loading state

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
  Future<void> _saveUserData(Map<String, dynamic> responseData) async {
    final prefs = await SharedPreferences.getInstance();

    // Capitalize the first letter of full name safely
    String fullName = (responseData['user']?['full_name'] ?? '').toString().trim();
    fullName = fullName.isNotEmpty
        ? '${fullName[0].toUpperCase()}${fullName.substring(1).toLowerCase()}'
        : '';

    // Save the access token safely
    await prefs.setString('access_token', responseData['token']?.toString() ?? '');
    // Save other user data with null checks
    await prefs.setString('full_name', fullName);
    await prefs.setString('email', responseData['user']?['email']?.toString() ?? '');
    await prefs.setInt('userid', responseData['user']['id'] ?? '');
    await prefs.setStringList('user_types', List<String>.from(responseData['user']?['userTypes'] ?? []));
    await prefs.setString('profile_image', responseData['user']?['profileImage']?.toString() ?? '');
    await prefs.setString('city', responseData['user']?['city']?.toString() ?? '');
    // Save business profile information
    if (responseData.containsKey('businessProfile')) {
      final businessProfile = responseData['businessProfile'];
      if (businessProfile is Map<String, dynamic>) {
        await prefs.setInt('profile_id', businessProfile['profileId'] ?? 0);
        await prefs.setInt('business_profile_id', businessProfile['businessProfileId'] ?? 0);
      }
    }
  }


  Future<void> _registerUser() async {
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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

    final nameParts = fullName.split(' ');
    final firstName = nameParts[0];
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    setState(() {
      _isLoading = true; // Start the loader
    });

    try {
      final responseData = await AuthService().registerUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        userTypes: ['registered-user'],
      );
      await _saveUserData(responseData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully',
            style: TextStyle(color: Colors.black), // Text color black
          ),
          backgroundColor: Color(0xFFDADADA), // Gray background color
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivateAccountScreen(email: email),
        ),
      );
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white, // White background for the status bar
        statusBarIconBrightness:
            Brightness.dark, // Dark icons for the status bar
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFD8DADC),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey, // Attach the form key
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(20), // Rounded bottom-left corner
                    bottomRight:
                        Radius.circular(20), // Rounded bottom-right corner
                  ),
                  child: Container(
                    color: Color(0xFFD8DADC),
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 70.0, bottom: 6.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Start Now',
                            style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 10),
                          Image.asset(
                            'assets/star.png',
                            width: 49,
                            height: 49,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 10),

                Container(
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
                    padding:
                        const EdgeInsets.all(16.0), // Adjust internal padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomInputField(
                          labelText: 'Full Name',
                          hintText:
                              'Enter your full name', // Pass custom hint text here
                          controller: _nameController,
                        ),
                        SizedBox(height: 12),
                        CustomInputField(
                          labelText: 'Email',
                          hintText:
                              'Enter your Email', // Pass custom hint text here
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
                          child: ElevatedButton(
                            onPressed: _validateEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isButtonEnabled
                                  ? Color(0XFF313131)
                                  : Color(0xFFC3C1C1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text(
                                    'Create Account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        // Add additional form content here if needed
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color(0xFFD9D9D9),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or Register with',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(
                                      0.7), // Black with 70% opacity
                                  fontFamily:
                                      'Inter', // Set the font family to 'Inter'
                                  fontWeight:
                                      FontWeight.w400, // Set font weight to 400
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
                        // SizedBox(height: 12),
                        // Column(
                        //   children: [
                        //     SocialMediaButton(
                        //       onPressed: () {
                        //         // Add your onPressed code here!
                        //       },
                        //       image: AssetImage('assets/google.png'),
                        //       label: 'Continue with Google',
                        //     ),
                        //     SizedBox(height: 10),
                        //     SocialMediaButton(
                        //       onPressed: () {
                        //         // Add your onPressed code here!
                        //       },
                        //       image: AssetImage('assets/facebook.png'),
                        //       label: 'Continue with Facebook',
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 12),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? ',
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
                                        MaterialPageRoute(builder: (context) => SignInScreen()),
                                      );
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'SF Pro Display', // Set the font family to 'SF Pro Display'
                                        fontWeight: FontWeight.w500, // Set font weight to 500
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2), // Add some spacing between the two sections
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => SliderScreen()), // Replace with your main menu screen
                                        (Route<dynamic> route) => false,
                                  );
                                },
                                child: Text(
                                  'Go to Main Menu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 220),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
