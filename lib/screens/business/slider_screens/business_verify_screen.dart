import 'package:flutter/material.dart';

class BusinessVerifyScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final VoidCallback onNext; // Callback to move to the next slide

  BusinessVerifyScreen({required this.onNext}); // Accept the onNext callback

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
              'You Almost done !',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Description
            Text(
              'Please enter your Gmail address below to receive a verification link.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              'Verify your email',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                  String email = _emailController.text;
                  if (email.isNotEmpty) {
                    print('Verification email sent to: $email');
                    onNext(); // Call onNext to go to the next slide
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
