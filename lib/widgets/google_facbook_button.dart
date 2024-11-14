import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon; // Optional Icon
  final ImageProvider? image; // Optional Image
  final String label;

  const SocialMediaButton({
    required this.onPressed,
    this.icon,
    this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: _buildIconOrImage(),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.black, // Set text color to black
          fontSize: 14, // Set font size
          fontFamily: 'Inter', // Set the font family to 'Inter'
          fontWeight: FontWeight.w600, // Set font weight to 600

        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFFD8DADC), width: 1), // Border color and width
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        minimumSize: Size(double.infinity, 50), // Fixed width and height
      ),
    );
  }

  /// Builds the icon or image depending on what's provided.
  Widget _buildIconOrImage() {
    if (image != null) {
      return Image(
        image: image!,
        width: 18, // Fixed image width
        height: 18, // Fixed image height
      );
    } else if (icon != null) {
      return Icon(
        icon,
        size: 18, // Fixed icon size
        color: Colors.black, // Default icon color
      );
    } else {
      return SizedBox.shrink(); // Empty placeholder if neither is provided
    }
  }
}
