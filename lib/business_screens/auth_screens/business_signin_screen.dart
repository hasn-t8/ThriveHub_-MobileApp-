import 'package:flutter/material.dart';
import '../../core/constants/text_styles.dart';
import 'business_signup_screen.dart';
import '../../widgets/input_fields.dart';
import '../slider_screens/business_slider_screen.dart';

class BusinessSignInScreen extends StatefulWidget {
  const BusinessSignInScreen({super.key});

  @override
  _BusinessSignInScreenState createState() => _BusinessSignInScreenState();
}

class _BusinessSignInScreenState extends State<BusinessSignInScreen> {
  bool _obscureText = true;
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
    if (_isButtonEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SliderScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor, // Use constant for background color
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section
            Container(
              color: kDividerColor, // Use constant for divider color
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80.0, bottom: 6.0),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Welcome Back!', style: kHeadingTextStyle), // Constant text style
                        const SizedBox(width: 10),
                        Image.asset('assets/star.png', width: 49, height: 49),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We\'re excited to see you again. Log in to continue \nyour journey with us.',
                      style: kSubheadingTextStyle, // Constant text style
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email Field
                  CustomInputField(
                    labelText: 'Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  // Password Field
                  CustomInputField(
                    labelText: 'Password',
                    controller: _passwordController,
                    obscureText: _obscureText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Forget password logic
                      },
                      child: Text('Forget Password?', style: kUnderlineTextStyle),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Log In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? _login : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isButtonEnabled
                            ? kPrimaryColor
                            : kSecondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, kButtonHeight),
                      ),
                      child: Text('Log In', style: kButtonTextStyle),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Or Divider
                  const Row(
                    children: [
                      Expanded(child: Divider(color: kDividerColor, thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or Log in with', style: kSubheadingTextStyle),
                      ),
                      Expanded(child: Divider(color: kDividerColor, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Social Login Buttons
                  Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // Google login logic
                        },
                        icon: const Icon(Icons.g_translate),
                        label: const Text(
                          'Continue with Google',
                          style: TextStyle(color: kTextColor),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: kDividerColor, width: 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, kButtonHeight),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Facebook login logic
                        },
                        icon: const Icon(Icons.facebook),
                        label: const Text(
                          'Continue with Facebook',
                          style: TextStyle(color: kTextColor),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: kDividerColor, width: 3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, kButtonHeight),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  // Sign Up Prompt
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account? ', style: kSubheadingTextStyle),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BusinessSignUpScreen()),
                            );
                          },
                          child: Text('Sign up', style: kUnderlineTextStyle),
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
