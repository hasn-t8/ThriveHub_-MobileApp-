import 'package:flutter/material.dart';
import 'package:thrive_hub/core/utils/email_validator.dart';
import '../../../core/constants/text_styles.dart';

class BusinessVerifyScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final VoidCallback onNext; // Callback to move to the next slide

  BusinessVerifyScreen({required this.onNext}); // Accept the onNext callback

  void _validateEmail(BuildContext context) {
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
    // Proceed to the next step
    print('Verification email sent to: $email');
    onNext(); // Trigger the callback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'You Almost Done!',
              style: bSubheading2TextStyle,
            ),
            SizedBox(height: 16),

            // Description
            Text(
              'Please enter your Gmail address below to receive a verification link.',
              style: bDescriptionTextStyle,
            ),
            SizedBox(height: 12),
            Text(
              'Verify your email',
              style: bHeadingTextStyle,
            ),
            SizedBox(height: 25),

            // Input Box for Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'example@gmail.com',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 32),

            // Send Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_emailController.text.isNotEmpty) {
                    _validateEmail(context); // Pass the context to validate email
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid email.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF828282),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 56),
                ),
                child: Text(
                  'Send Code',
                  style: kButtonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
