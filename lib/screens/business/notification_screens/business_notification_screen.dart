import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/widgets/toggle_bar.dart';
import 'package:thrive_hub/screens/user/search_screens/filter_screen.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';
import 'package:thrive_hub/widgets/notification_card.dart';
import 'package:thrive_hub/widgets/sort.dart'; // Import the NotificationCard widget


class BusinessNotificationScreen extends StatefulWidget {
  @override
  _BusinessNotificationScreenState createState() =>
      _BusinessNotificationScreenState();
}

class _BusinessNotificationScreenState
    extends State<BusinessNotificationScreen> {
  bool isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  // Sample notification data
  List<Map<String, dynamic>> notifications = [
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'title': 'Dropbox',
      'time': '23 min ago',
      'message': 'Dropbox responded to your comment',
      'hasRedDot': true,
    },
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'title': 'Google Drive',
      'time': '1 hour ago',
      'message':
      'Google Drive shared a file with youGoogle Drive shared a file with youGoogle Drive shared a file with you',
      'hasRedDot': false,
    },
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'title': 'Thrive Hub',
      'time': '3 hours ago',
      'message': 'Thrive Hub is an ecommerce platform',
      'hasRedDot': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notification',
        showBackButton: true,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        children: [
          NotificationToggleWidget(
            title: 'Sound Notification',
            isToggled: isNotificationEnabled,
            onToggle: (value) {
              setState(() {
                isNotificationEnabled = value;
              });
              print('Notification toggle: $value');
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0), // Adjust vertical space as needed
            child: Divider(
              color: Color(0xFFE9E9EA),
              thickness: 1, // Thickness of the divider line
            ),
          ),

          FilterSortButtons(
            onFilter: (context) async {
              // Your filter logic here
              return await Navigator.push<List<String>>(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              ) ?? [];
            },
            onSort: (context) async {
              // Your sort logic here
              return await showModalBottomSheet<String>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const SortBottomSheet(
                  title: 'Sort', // Pass custom title
                  sortOptions: ['By Service', 'No answer', 'with answer', 'Newest'], // Pass custom options

                ),
              );
            },
            onFiltersUpdated: (updatedFilters) {
              // Handle the updated filters in the parent widget
              print("Filters updated: $updatedFilters");
              // Optionally update additional UI or state here
            },
          ),

          SizedBox(height: 10),
          Expanded(
            child: notifications.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/main.png', // Replace with your image asset
                    width: 226,
                    height: 196,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'You have no notifications yet',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: NotificationCard(
                    imageUrl: notification['imageUrl'],
                    title: notification['title'],
                    time: notification['time'],
                    message: notification['message'],
                    hasRedDot: notification['hasRedDot'] ?? false,
                    isBusinessProfile: true,
                    onViewTap: () {
                      print('Notification card tapped!');
                    },
                    onReplyTap: () {
                      print('Reply button tapped for notification');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
