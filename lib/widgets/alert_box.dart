import 'package:flutter/material.dart';

class CustomAlertBox extends StatelessWidget {
  final String? imagePath; // Make imagePath nullable
  final String title; // Make title non-nullable
  final String message; // Make message non-nullable

  CustomAlertBox({this.imagePath, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),

      backgroundColor: Color(0xFFF8F8F8),
      child: Container(
        width: 310,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
          children: <Widget>[
            if (imagePath != null && imagePath!.isNotEmpty) // Check if imagePath is not null and not empty
              Image.asset(
                imagePath!,
                width: 164,
                height: 142,
                fit: BoxFit.cover,
              ),
            if (imagePath != null && imagePath!.isNotEmpty)
              SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16), // Add spacing at the bottom
          ],
        ),
      ),
    );
  }
}
