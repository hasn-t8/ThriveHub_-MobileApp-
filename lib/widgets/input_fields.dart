import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? hintText;
  final Color borderColor; // Add a borderColor property

  CustomInputField({
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.hintText,
    this.borderColor = const Color(0xFFEDF1F3), // Default border color
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor, // Use the customizable border color
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3DE4E5E7),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextField( // Use TextField instead of TextFormField
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              hintText: hintText ?? labelText, // Use hintText if provided, fallback to labelText
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
        )
      ],
    );
  }
}
