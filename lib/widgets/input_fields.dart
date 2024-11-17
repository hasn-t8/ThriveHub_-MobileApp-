import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? hintText;
  final Color borderColor; // Border color for the input field
  final Color labelColor; // Label text color
  final double labelFontSize; // Label font size
  final List<BoxShadow>? boxShadow; // Box shadow for the container

  CustomInputField({
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.hintText,
    this.borderColor = const Color(0xFFEDF1F3), // Default border color
    this.labelColor = const Color(0xFF000000), // Default label color
    this.labelFontSize = 12, // Default label font size
    this.boxShadow = const [
      BoxShadow(
        color: Color(0x3DE4E5E7), // Default shadow color
        offset: Offset(0, 1), // Default shadow offset
        blurRadius: 2, // Default shadow blur radius
      ),
    ], // Default box shadow
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: labelFontSize, // Use customizable label font size
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            color: labelColor, // Use customizable label color
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor, // Use the customizable border color
              width: 1,
            ),
            boxShadow: boxShadow, // Use the customizable box shadow
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              hintText: hintText ?? labelText, // Use hintText if provided
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.01,
                height: 19.6 / 14,
                textBaseline: TextBaseline.alphabetic,
                color: Color(0xFFA5A5A5),
              ),
              suffixIcon: suffixIcon,
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
