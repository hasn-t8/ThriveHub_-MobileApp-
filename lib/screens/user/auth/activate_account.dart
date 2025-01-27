import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_slider_screen.dart';
import 'package:thrive_hub/screens/user/auth/sign_in.dart';
import 'package:thrive_hub/services/auth_services/auth_service.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/bottom_navigation_bar.dart';
import 'create_new_password.dart';

class ActivateAccountScreen extends StatefulWidget {
  final String email;

  ActivateAccountScreen({required this.email});

  @override
  _ActivateAccountScreenState createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends State<ActivateAccountScreen> {
  final _codeController = List<TextEditingController>.generate(4, (index) => TextEditingController());
  final _focusNodes = List<FocusNode>.generate(4, (index) => FocusNode());
  final _borderColors = List<Color>.generate(4, (index) => Color(0xFFA5A5A5)); // Default border colors
  Timer? _timer;
  int _startTimer = 60;
  bool _isLoading = false; // Track the loading state

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_startTimer == 0) {
          timer.cancel();
        } else {
          _startTimer--;
        }
      });
    });
  }

  void resendCode() async {
    final authService = AuthService(); // Create an instance of AuthService
    bool isCodeSent = await authService.ResendCodeApi(widget.email); // Call the resendCode API
    if (isCodeSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code sent successfully!'), backgroundColor: Colors.green),
      );
      setState(() {
        _startTimer = 60;
        startTimer();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please try again.'), backgroundColor: Colors.red),
      );
    }
  }

  void verifyCode() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final authService = AuthService(); // Create an instance of AuthService
    String enteredCode = _codeController.map((controller) => controller.text).join();

    // Call the API to verify the code
    bool isCodeValid = await authService.ActivateCodeApi(widget.email, enteredCode); // Verify code API

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (isCodeValid) {
      final prefs = await SharedPreferences.getInstance();
      final userTypes = prefs.getStringList('user_types') ?? [];

      if (userTypes.contains('business-owner')) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BusinessSliderScreen()),
              (Route<dynamic> route) => false,
        );
      } else if (userTypes.contains('registered-user')) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User type not recognized.'), backgroundColor: Colors.orange),
        );
      }
    } else {
      setState(() {
        for (int i = 0; i < _borderColors.length; i++) {
          _borderColors[i] = Color(0xFFFB0000); // Red border color
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid code, please try again.'), backgroundColor: Colors.red),
      );
    }
  }

  void resetBorders() {
    setState(() {
      for (int i = 0; i < _borderColors.length; i++) {
        _borderColors[i] = Color(0xFFA5A5A5); // Default border color
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showBackButton: true),
      backgroundColor: Color(0xFFFFFFFF),
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
                        'Activate Account',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF475569),
                            height: 1.8,
                            letterSpacing: 0.01,
                          ),
                          children: [
                            TextSpan(text: 'Code has been sent to '),
                            TextSpan(
                              text: widget.email,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(text: '\nEnter the code to Activate your account.'),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Change e-mail',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Code input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _codeController[index],
                        focusNode: _focusNodes[index],
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _borderColors[index],
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: _borderColors[index],
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.length == 1) {
                            resetBorders();
                            if (index < 3) {
                              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          } else if (value.isEmpty) {
                            if (index > 0) {
                              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                            }
                          }
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      if (_startTimer > 0)
                        Text(
                          'Code expires in: ${_startTimer ~/ 60}:${(_startTimer % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1E1E1E),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      if (_startTimer == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Didn’t receive code? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1E1E1E),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                resendCode();
                              },
                              child: Text(
                                'Resend Code',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : verifyCode, // Disable button while loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6A6A6A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white) // Show loader while loading
                        : Text(
                      'Activate Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
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
