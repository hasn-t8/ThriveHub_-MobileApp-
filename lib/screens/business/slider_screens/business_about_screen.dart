import 'package:flutter/material.dart';

class BusinessAboutScreen extends StatefulWidget {
  final VoidCallback onSkip; // Callback to handle skip action
  final VoidCallback onNext; // Callback to handle next action

  BusinessAboutScreen({required this.onSkip, required this.onNext});

  @override
  _BusinessAboutScreenState createState() => _BusinessAboutScreenState();
}

class _BusinessAboutScreenState extends State<BusinessAboutScreen> {
  String _description = ''; // Store the description

  @override
  void initState() {
    super.initState();
    _description = ''; // Load saved data if needed
  }

  void _autoSave(String value) {
    setState(() {
      _description = value;
    });
    print("Auto-saved: $_description");
    // Add save to local storage, database, or server logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'About Your Business',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: 198,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFEFEFF0),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: _autoSave,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Write about the company...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Icon(
                    Icons.edit,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Space before Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onNext, // Trigger the next action
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF828282),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Space before Skip button
            Center(
              child: TextButton(
                onPressed: widget.onSkip, // Trigger the skip action
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Color(0xFF4D4D4D),
                    fontSize: 16,
                    decoration: TextDecoration.underline, // Adds underline
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
