import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import '../../../widgets/input_fields.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordsMatch = true;

  @override
  void initState() {
    super.initState();
    // Add listeners to update border color in real time
    _passwordController.addListener(_validatePasswords);
    _confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
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
                    'Create New Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Inter', // Set the font family to 'Inter'
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please enter and confirm your new password.\nYou will need to login after you reset.',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Inter', // Set the font family to 'Inter'
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF475569),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Password field using CustomInputField
            CustomInputField(
              labelText: 'Password',
              controller: _passwordController,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: _obscurePassword
                      ? Color(0xFFACB5BB)
                      : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              borderColor: _passwordsMatch
                  ? Color(0xFFEDF1F3)
                  : Color(0xFFFB0000), // Dynamic border color
            ),
            SizedBox(height: 12),
            // Confirm Password field using CustomInputField
            CustomInputField(
              labelText: 'Confirm Password',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: _obscureConfirmPassword
                      ? Color(0xFFACB5BB)
                      : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              borderColor: _passwordsMatch
                  ? Color(0xFFEDF1F3)
                  : Color(0xFFFB0000), // Dynamic border color
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_passwordsMatch) {
                    // Handle successful password creation
                    Navigator.pop(context); // Example action
                  } else {
                    // Show an error or feedback to the user
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF313131), // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Reduced corner radius
                  ),
                  minimumSize: Size(double.infinity, 50), // Fixed height
                ),
                child: Text(
                  'Verify Account',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 14,
                    fontFamily: 'Inter', // Set the font family to 'Inter'
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}