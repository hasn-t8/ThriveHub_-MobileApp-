import 'package:flutter/material.dart';
import 'package:thrive_hub/core/constants/text_styles.dart';

class NotificationToggleWidget extends StatelessWidget {
  final String title;
  final bool isToggled; // Current state of the toggle
  final ValueChanged<bool> onToggle; // Callback when toggle changes

  const NotificationToggleWidget({
    Key? key,
    required this.title,
    required this.isToggled,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      height:44.0, // Updated fixed height
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white, // Background color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: bDescriptionTextStyle,
          ),
          GestureDetector(
            onTap: () => onToggle(!isToggled), // Toggle the state on tap
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 51.0, // Updated width
              height: 33.0, // Updated height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.5), // Rounded corners
                color: isToggled
                    ? Colors.black.withOpacity(0.8) // Active track color
                    : const Color(0xFF787880).withOpacity(0.16), // Inactive track color
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment:
                    isToggled ? Alignment.centerRight : Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 27.0, // Updated circle width
                      height: 27.0, // Updated circle height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Thumb color
                        boxShadow: [
                          if (!isToggled) // Add shadow only for inactive state
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0), // Inner padding
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isToggled
                                ? Colors.black.withOpacity(0.8) // Active inner circle color
                                : Colors.white, // Inactive inner circle color
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
