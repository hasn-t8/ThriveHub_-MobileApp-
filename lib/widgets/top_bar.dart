import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/screens/business/notification_screens/business_notification_screen.dart';
import 'package:thrive_hub/screens/user/notifications_screens/notification_screen.dart';

class HeaderWidget extends StatelessWidget {
  final String? heading;
  final bool showHeading;
  final bool showSearchBar;
  final bool showLine;
  final bool showLogo;
  final bool showNotificationIcon;

  // Added two new boolean parameters for logo and notification icon visibility
  HeaderWidget({
    this.heading,
    this.showHeading = true,
    this.showSearchBar = true,
    this.showLine = true,
    this.showLogo = true, // Default is true, shows logo
    this.showNotificationIcon = true, // Default is true, shows notification icon
  });

  // Method to handle the notification icon press based on user type
  Future<void> _onNotificationIconPressed(BuildContext context) async {
    // Get shared preferences instance
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the user types list from shared preferences
    final List<String>? userTypes = prefs.getStringList('user_types');

    // Check if the user type is 'business-owner' or 'registered-user'
    if (userTypes != null && userTypes.contains('business-owner')) {
      // If user is a business owner, navigate to business notification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusinessNotificationScreen(), // Business owner screen
        ),
      );
    } else if (userTypes != null && userTypes.contains('registered-user')) {
      // If user is a registered user, navigate to general notification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(), // Registered user screen
        ),
      );
    } else {
      // You can show a default screen or a message if no user type found
      print('No valid user type found!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showLogo)
                Image.asset(
                  'assets/logo.png', // Replace with the path of your logo
                  height: 35, // Adjust size of logo
                ),
              if (showNotificationIcon)
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: Color(0xFF3C3C43),
                  onPressed: () => _onNotificationIconPressed(context), // Handle notification icon press
                ),
            ],
          ),
          // Heading text (if enabled and heading is not null)
          if (showHeading && heading != null)
            Text(
              heading!,
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1.23,
                letterSpacing: 0.374,
                color: Colors.black,
              ),
            ),
          if (showHeading) SizedBox(height: 11),
          // Search bar
          if (showSearchBar)
            Container(
              height: 36,
              width: double.infinity,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFE9E9EA),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Color(0xFF3C3C43).withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFF3C3C43).withOpacity(0.6)),
                  suffixIcon: Icon(Icons.mic, color: Color(0xFF3C3C43).withOpacity(0.6)),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          if (showSearchBar) SizedBox(height: 9),
          // Line separator
          if (showLine)
            Container(
              height: 1,
              color: Color(0xFFE9E9EA),
            ),
        ],
      ),
    );
  }
}
