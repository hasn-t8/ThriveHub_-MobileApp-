import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/notification_card.dart'; // Import the NotificationCard widget

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
      'hasRedDot': true, // Show red dot
    },
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'title': 'Google Drive',
      'time': '1 hour ago',
      'message': 'Google Drive shared a file with you',
      'hasRedDot': false, // Do not show red dot
    },
    {
      'imageUrl': 'https://via.placeholder.com/150',
      'title': 'Thrive Hub',
      'time': '3 hours ago',
      'message': 'Thrive Hub is an ecommerce platform',
      'hasRedDot': false, // Show red dot
    },
    // Add more notifications as needed
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notification',
        showBackButton: true,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFFFFFF), // Set background color of the screen
      body: notifications.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/main.png', // Replace with your image asset
              width: 226,
              height: 196,
            ),
            SizedBox(height: 16.0),
            Text(
              'You have no notifications yet',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Inter', // Set the font family to 'Inter'
                fontWeight: FontWeight.w400, // Set font weight to 400
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
            padding: const EdgeInsets.symmetric(vertical: 2.0), // Adjust padding here
            child: NotificationCard(
              imageUrl: notification['imageUrl'],
              title: notification['title'],
              time: notification['time'],
              message: notification['message'],
              hasRedDot: notification['hasRedDot'] ?? false, // Default to false if null
              onViewTap: () {
                print('Notification card tapped!');
              },
            ),
          );
        },
      ),
    );
  }
}
