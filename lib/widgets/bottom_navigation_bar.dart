import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/screens/search_screens/all_categories.dart';
import 'package:thrive_hub/screens/search_screens/search_screen.dart';
import 'package:thrive_hub/screens/search_screens/sub_categories.dart';
import 'package:thrive_hub/screens/user/auth/sign_in.dart';
import 'package:thrive_hub/screens/user/reviews_screens/review_screen.dart';
import 'package:thrive_hub/screens/user/profile_screens/profile_screen.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Define each tab as a separate navigator or screen
  final List<Widget> _screens = [
    SearchNavigator(), // Custom Navigator for Search tab
    ReviewScreen(),
    AllCategoriesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) async {
    if (index == 0 || index == 1 || index == 2) {
      // Allow access to the Search tab (index 0) without login
      setState(() {
        _selectedIndex = index;
      });
    } else {
      // Check login status
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      List<String>? storedUserTypes = prefs.getStringList('user_types');
      if (accessToken == null || accessToken.isEmpty || (storedUserTypes == null || !storedUserTypes.contains('registered-user'))) {
        await prefs.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      }else {
        // If logged in, allow access to the selected tab
        setState(() {
          _selectedIndex = index;
        });
      }
    }
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
class SearchNavigator extends StatelessWidget {

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
