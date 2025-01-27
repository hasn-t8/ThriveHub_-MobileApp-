import 'package:flutter/material.dart';
import 'package:thrive_hub/services/auth_services/auth_service.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import '../../../widgets/input_fields.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  CreateNewPasswordScreen({required this.email});
  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _codeController = TextEditingController();

  bool _passwordsMatch = true;
  bool _isLoading = false; // For showing a loading indicator

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
    _codeController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _changePassword() async {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the code sent to your email.')),
      );
      return;
    }

    if (!_passwordsMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = AuthService();
      final response = await apiService.changePassword(
        email: widget.email,
        token: _codeController.text,
        newPassword: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset successful. Please log in.')),
        );
        Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to reset password.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showBackButton: true),
      backgroundColor: Color(0xFFFFFFFF), // Set the background color
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
        child: SingleChildScrollView(
          child: Padding(
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
                        'We have sent a code to your email. Enter the code, your new password, and confirm it to reset your password.',
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
                // Code field using CustomInputField
                CustomInputField(
                  labelText: 'Code',
                  controller: _codeController,
                  obscureText: false,
                  borderColor: Color(0xFFEDF1F3),
                ),
                SizedBox(height: 12),
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
                SizedBox(height: 20),
                if (_isLoading)
                  Center(child: CircularProgressIndicator()),
                if (!_isLoading)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF313131), // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Reduced corner radius
                        ),
                        minimumSize: Size(double.infinity, 50), // Fixed height
                      ),
                      child: Text(
                        'Reset Password',
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
        ),
      ),
    );
  }
}
