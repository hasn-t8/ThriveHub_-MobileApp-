import 'package:flutter/material.dart';
import 'package:thrive_hub/user_screens/search_screens/search_screen.dart';
import 'package:thrive_hub/user_screens/reviews_screens/review_screen.dart';
import 'package:thrive_hub/user_screens/notifications_screens/notification_screen.dart';
import 'package:thrive_hub/user_screens/profile_screens/profile_screen.dart';
import 'package:thrive_hub/user_screens/search_screens/sub_categories_screen.dart';

//
// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   final List<Widget> _screens = [
//     SearchScreen(),
//     ReviewScreen(),
//     NotificationScreen(),
//     ProfileScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed, // Ensures all items are displayed
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         iconSize: 24, // Set the icon size to 24
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.reviews_outlined),
//             label: 'Reviews',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications_outlined),
//             label: 'Notifications',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }


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
    NotificationScreen(),
    ProfileScreen(),
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

//
// // Inside SearchScreen
// Navigator.of(context).pushNamed('/subcategories');
