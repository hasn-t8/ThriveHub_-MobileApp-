import 'package:flutter/material.dart';

class CustomAlertBox extends StatelessWidget {
  final String? imagePath; // Optional imagePath
  final String title; // Required title
  final String message; // Required message
  final String? name; // Optional name

  CustomAlertBox({
    this.imagePath,
    required this.title,
    required this.message,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16), // Top-left border radius
        ),
      ),
      backgroundColor: Color(0xFFF8F8F8),
      child: Container(
        width: 315,
        height: 288,
        padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Display image if imagePath is provided
            if (imagePath != null && imagePath!.isNotEmpty)
              Image.asset(
                imagePath!,
                width: 164.5,
                height: 142.51,
                fit: BoxFit.cover,
              ),
            if (imagePath != null && imagePath!.isNotEmpty)
              SizedBox(height: 8),

            // Title and optional name
            Align(
              alignment: Alignment.centerLeft, // Align to the left
              child: Center(
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: 0.3376,
                      color: Colors.black, // Set text color to black
                    ),
                    children: [
                      if (name != null && name!.isNotEmpty)
                        TextSpan(
                          text: ' $name',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black, // Set text color to black
                            height: 1.2,
                            letterSpacing: 0.3376,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),

            // Message
            Container(
              alignment: Alignment.center,
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  textBaseline: TextBaseline.alphabetic,

                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
