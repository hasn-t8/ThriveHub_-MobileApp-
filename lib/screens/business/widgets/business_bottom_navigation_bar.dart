
import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/profile_screens/business_profile_screen.dart';
import 'package:thrive_hub/screens/business/reviews_screens/business_review_screen.dart';
import 'package:thrive_hub/screens/business/notification_screens/business_notification_screen.dart';
import 'package:thrive_hub/screens/search_screens/all_categories.dart';
import 'package:thrive_hub/screens/search_screens/search_screen.dart';
import 'package:thrive_hub/screens/search_screens/sub_categories.dart';

class BusinessMainScreen extends StatefulWidget {
  @override
  _BusinessMainScreenState createState() => _BusinessMainScreenState();
}

class _BusinessMainScreenState extends State<BusinessMainScreen> {
  int _selectedIndex = 0;

  // Define each tab as a separate navigator or screen
  final List<Widget> _screens = [
    BusinessSearchNavigator(),
    BusinessReviewScreen(),
    AllCategoriesScreen(),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensure all items are displayed
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 24, // Set icon size
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews_outlined),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
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

// Custom navigator for Search tab
class BusinessSearchNavigator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/subcategories':
            return MaterialPageRoute(
              builder: (_) => SubcategoriesScreen(categoryTitle: ''),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => SearchScreen(),
            );
        }
      },
    );
  }
}