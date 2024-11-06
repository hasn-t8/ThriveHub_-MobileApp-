import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/notification_card.dart'; // Import the NotificationCard widget

class NotificationScreen extends StatelessWidget {
  // Sample notification data
  final List<Map<String, dynamic>> notifications = [
    {
      'imageUrl': 'https://via.placeholder.com/40', // Replace with your image URL
      'title': 'Dropbox',
      'time': '23 min ago',
      'message': 'Dropbox responded to your comment',
    },
    {
      'imageUrl': 'https://via.placeholder.com/40', // Replace with your image URL
      'title': 'Google Drive',
      'time': '1 hour ago',
      'message': 'Google Drive shared a file with you',
    },
    {
      'imageUrl': 'https://via.placeholder.com/40', // Replace with your image URL
      'title': 'Thrive Hub',
      'time': '3 hours ago',
      'message': 'Thrive Hub is an ecommerce platform',
    },
    // Add more notifications as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notification',
        showBackButton: false,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF1F3F4), // Set background color of the screen
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
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCard(
            imageUrl: notification['imageUrl'],
            title: notification['title'],
            time: notification['time'],
            message: notification['message'],
            onViewTap: () {
              // Handle view action
            },
          );
        },
      ),
    );
  }
}
