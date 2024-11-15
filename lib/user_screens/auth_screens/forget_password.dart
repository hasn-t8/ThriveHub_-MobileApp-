import 'package:flutter/material.dart';
import 'package:thrive_hub/validators/email_validator.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'verify_account.dart'; // Import the VerifyAccountScreen
import '../../widgets/input_fields.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final ValueNotifier<bool> _isEmailEmpty = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      _isEmailEmpty.value = _emailController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _isEmailEmpty.dispose();
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showBackButton: true),
      backgroundColor: Color(0xFFFFFFFF), // Set the background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Inter', // Set the font family to 'Inter'
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No worries! Enter your email address below and we will send you a code to reset your password.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter', // Set the font family to 'Inter'
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF475569),
                      height: 22 / 14, // Line height (line-height divided by font-size)
                      letterSpacing: 0.01, // Letter spacing
                    ),
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
            SizedBox(height: 20),
            // Email field using CustomInputField
            CustomInputField(
              labelText: 'Email',
              hintText:
              'Enter your email', // Pass custom hint text here
              controller: _emailController,
            ),
            Spacer(),
            ValueListenableBuilder<bool>(
              valueListenable: _isEmailEmpty,
              builder: (context, isEmailEmpty, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isEmailEmpty
                        ? null
                        : () {
                      String email = _emailController.text.trim();

                      // Validate email before navigating
                      final validationError = emailValidator(email);
                      if (validationError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(validationError),
                            backgroundColor: Colors.black,
                          ),
                        );
                        return; // Stop execution if validation fails
                      }

                      // Navigate to VerifyAccountScreen if email is valid
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyAccountScreen(email: email),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEmailEmpty ? Color(0xFF6A6A6A) : Color(0xFF313131), // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Reduced corner radius
                      ),
                      minimumSize: Size(double.infinity, 50), // Fixed height
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white, // Text color
                        fontSize: 14,
                        fontFamily: 'Inter', // Set the font family to 'Inter'
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
