
import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/profile_screens/business_profile_screen.dart';
import 'package:thrive_hub/screens/business/reviews_screens/business_review_screen.dart';
import 'package:thrive_hub/screens/business/notification_screens/business_notification_screen.dart';
import 'package:thrive_hub/screens/business/search_screens/business_search_screen.dart';

class BusinessMainScreen extends StatefulWidget {
  @override
  _BusinessMainScreenState createState() => _BusinessMainScreenState();
}

class _BusinessMainScreenState extends State<BusinessMainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    BusinessSearchScreen(),
    BusinessReviewScreen(),
    BusinessNotificationScreen(),
    BusinessProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures all items are displayed
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 24, // Set the icon size to 24
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews_outlined),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}