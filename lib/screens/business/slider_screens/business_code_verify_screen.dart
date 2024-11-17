import 'package:flutter/material.dart';
import 'dart:async';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/business_screens/widgets/business_bottom_navigation_bar.dart';

class BusinessCodeVerifyScreen extends StatefulWidget {
  final VoidCallback onDone; // Callback to handle the done action
  final VoidCallback onResendCode; // Callback to handle resend code action

  BusinessCodeVerifyScreen({required this.onDone, required this.onResendCode});

  @override
  _BusinessCodeVerifyScreenState createState() => _BusinessCodeVerifyScreenState();
}

class _BusinessCodeVerifyScreenState extends State<BusinessCodeVerifyScreen> {
  List<TextEditingController> _controllers = List.generate(
    6,
        (index) => TextEditingController(),
  );

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
      body: SingleChildScrollView( // Enables scrolling when the screen is filled
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Heading
              Text(
                'Thank You!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              // Description
              Text(
                'Lorem ipsum dolor sit amet consectetur. Quisque aenean eu nunc tempor iaculis. Please enter the 6-digit code sent to your email.',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 25),

              // Subtitle above code boxes
              Text(
                'We just sent you a code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),

              // 6-digit input boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                      (index) => SizedBox(
                    width: 45,
                    height: 40,
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '', // Removes the character count
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                        else if (value.isEmpty && index > 0) {
                          // Move focus to the previous field on backspace
                          FocusScope.of(context).previousFocus();
                        }

                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Done Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Collect the code from the input boxes
                    String code = _controllers.map((c) => c.text).join();
                    if (code.length == 6) {
                      widget.onDone();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                            (Route<dynamic> route) => false, // Remove all previous routes
                      );// Trigger the done action
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a 6-digit code.')),
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
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
