//
// import 'package:flutter/material.dart';
// import 'package:thrive_hub/user_screens/search_screens/business_search_screen.dart';
// import 'package:thrive_hub/user_screens/reviews_screens/business_review_screen.dart';
// import 'package:thrive_hub/user_screens/notifications_screens/business_notification_screen.dart';
// import 'package:thrive_hub/user_screens/profile_screens/business_profile_screen.dart';
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
//       bottomNavigationBar: Container(
//         height: 93, // Set the height of the BottomNavigationBar
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed, // Ensures all items are displayed
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           items: [
//             BottomNavigationBarItem(
//               icon: CustomBottomNavigationItem(
//                 icon: Icons.search,
//                 label: 'Search',
//               ),
//               label: '', // Remove default label
//             ),
//             BottomNavigationBarItem(
//               icon: CustomBottomNavigationItem(
//                 icon: Icons.rate_review,
//                 label: 'Review',
//               ),
//               label: '', // Remove default label
//             ),
//             BottomNavigationBarItem(
//               icon: CustomBottomNavigationItem(
//                 icon: Icons.notifications,
//                 label: 'Notifications',
//               ),
//               label: '', // Remove default label
//             ),
//             BottomNavigationBarItem(
//               icon: CustomBottomNavigationItem(
//                 icon: Icons.person,
//                 label: 'Profile',
//               ),
//               label: '', // Remove default label
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CustomBottomNavigationItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//
//   CustomBottomNavigationItem({
//     required this.icon,
//     required this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 76,
//       height: 49,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 24, // Adjust the icon size as needed
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 10, // Adjust the label size as needed
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:thrive_hub/user_screens/search_screens/search_screen.dart';
import 'package:thrive_hub/user_screens/reviews_screens/review_screen.dart';
import 'package:thrive_hub/user_screens/notifications_screens/notification_screen.dart';
import 'package:thrive_hub/user_screens/profile_screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    SearchScreen(),
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