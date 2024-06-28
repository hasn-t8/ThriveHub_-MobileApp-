import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const SocialMediaButton({
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label,
        style: TextStyle(color: Colors.black), // Set text color to black
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFFD8DADC), width: 3), // Border color and width
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Reduced corner radius
        ),
        minimumSize: Size(double.infinity, 50), // Fixed width and height
      ),
    );
  }
}
