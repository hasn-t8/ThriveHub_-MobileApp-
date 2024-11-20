import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/google_facbook_button.dart';
import '../../../core/constants/text_styles.dart';
import 'sign_up.dart';
import '../slider_screens/business_slider_screen.dart';
import '../../../widgets/forms/login_form.dart';
import '../../../widgets/forms/social_login.dart';
import '../../../widgets/headers/custom_header_1.dart';

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
        MaterialPageRoute(builder: (context) => BusinessSliderScreen()),
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
              child: const Center(
                child: Column(
                  children: [
                    CustomHeaderTh(
                      headingText: 'Welcome Back!',
                      headingImagePath: 'assets/star.png',
                      subheadingText:
                          'We\'re excited to see you again. Log in to continue \nyour journey with us.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LoginForm(
                onSubmit: () {
                  Navigator.pushNamed(context, '/business-home'); // Navigate to signup
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SliderScreen()),
                  // );
                  // Handle login success here
                  print('Login Successful');
                },
              ),
            ),
            // Form Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kPaddingHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Or Divider
                  const Row(
                    children: [
                      Expanded(
                          child: Divider(color: kDividerColor, thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child:
                            Text('Or Log in with', style: kSubheadingTextStyle),
                      ),
                      Expanded(
                          child: Divider(color: kDividerColor, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 40),
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
                  // const SizedBox(height: 20),
                  // Sign Up Prompt
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account? ',
                            style: kSubheadingTextStyle),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/business-sign-up'); // Navigate to signup
                          },
                          child:
                              const Text('Sign up', style: kUnderlineTextStyle),
                        ),
                        const SizedBox(height: 100),
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
