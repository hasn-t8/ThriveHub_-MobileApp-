import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;

  CustomInputField({
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5A5A5A), // Set the label color here
          ),
        ),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFA5A5A5)),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            hintText: 'Enter your $labelText',
            suffixIcon: suffixIcon,
          ),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
