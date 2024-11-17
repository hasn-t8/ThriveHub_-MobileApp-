import 'package:flutter/material.dart';

class ProfileListItem extends StatelessWidget {
  final IconData leadingIcon;
  final String text;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final Color? leadingIconColor;
  final Color? textColor;
  final Border? border; // Optional custom border

  const ProfileListItem({
    Key? key,
    required this.leadingIcon,
    required this.text,
    this.trailingIcon,
    this.onTap,
    this.leadingIconColor = Colors.black,
    this.textColor = Colors.black,
    this.border, // Allow users to pass a custom border
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 343,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          border: border ?? const Border( // Use the custom border or fallback to default
            bottom: BorderSide(
              color: Color(0xFFE9E8E8),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(leadingIcon, size: 20, color: leadingIconColor),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, size: 16, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
