import 'package:flutter/material.dart';
import 'package:thrive_hub/core/utils/email_validator.dart';
import 'package:thrive_hub/screens/user/auth/create_new_password.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'verify_account.dart'; // Import the VerifyAccountScreen
import '../../../widgets/input_fields.dart';
import 'package:thrive_hub/services/auth_services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final ValueNotifier<bool> _isEmailEmpty = ValueNotifier<bool>(true);
  bool _isLoading = false;

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

  void _handleContinue() async {
    final email = _emailController.text.trim();

    // Validate email before proceeding
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

    setState(() {
      _isLoading = true; // Show loader
    });

    // Call the AuthService function
    final response = await AuthService().sendResetPasswordEmail(email);

    setState(() {
      _isLoading = false; // Hide loader
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response['message']),
        backgroundColor: response['success'] ? Colors.green : Colors.red,
      ),
    );

    // Navigate to the VerifyAccountScreen if successful
    if (response['success']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNewPasswordScreen(email: email),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showBackButton: true),
      backgroundColor: Color(0xFFFFFFFF),
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
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No worries! Enter your email address below and we will send you a code to reset your password.',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF475569),
                      height: 22 / 14,
                      letterSpacing: 0.01,
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
              hintText: 'Enter your email',
              controller: _emailController,
            ),
            Spacer(),
            ValueListenableBuilder<bool>(
              valueListenable: _isEmailEmpty,
              builder: (context, isEmailEmpty, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isEmailEmpty || _isLoading
                        ? null
                        : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEmailEmpty
                          ? Color(0xFF6A6A6A)
                          : Color(0xFF313131),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                        : Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
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
