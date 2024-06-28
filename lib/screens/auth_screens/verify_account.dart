import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';

import '../profile_screens/account_settings_screen.dart';


class VerifyAccountScreen extends StatefulWidget {
  final String email; // Add email parameter

  VerifyAccountScreen({required this.email}); // Modify constructor to accept email

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final _codeController =
  List<TextEditingController>.generate(4, (index) => TextEditingController());
  final _focusNodes = List<FocusNode>.generate(4, (index) => FocusNode());

  Timer? _timer;
  int _startTimer = 60; // Timer duration in seconds

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

  void resendCode() {
    setState(() {
      _startTimer = 60;
      startTimer();
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
                    'Verify Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: 'Code has been sent to '),
                        TextSpan(
                          text: widget.email,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '\nEnter the code to verify your account.'),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // Go back to the previous screen
                        },
                        child: Text(
                          'Change Email?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline, // Add this line for underline
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
                      counterText: "", // Removes the 0/1 below the box
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFA5A5A5)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                    keyboardType: TextInputType.number,
                    maxLength: 1, // Ensures each box accepts only one character
                    onChanged: (value) {
                      if (value.length == 1) {
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
                      'Code expire in: ${_startTimer ~/ 60}:${(_startTimer % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
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
                            color: Colors.black,
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
                              fontWeight: FontWeight.bold,
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
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Add your onPressed code here!

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
                    fontSize: 16,
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
