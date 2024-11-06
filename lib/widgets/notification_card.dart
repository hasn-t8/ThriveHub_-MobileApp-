//import
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String time;
  final String message;
  final VoidCallback onViewTap;

  const NotificationCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.message,
    required this.onViewTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF1F3F4), // Set background color
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.transparent, // Set card background color to transparent
        elevation: 0, // Remove card shadow
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFFF1F3F4), // Set container background color to match screen background
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFD9D9D9),
                    radius: 20.0,
                    backgroundImage: NetworkImage(imageUrl), // Replace with your image URL
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      title, // Replace with your notification title
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    time, // Replace with your notification time
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                message, // Replace with your notification message
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                  // color: Colors.grey,
                ),
              ),
              SizedBox(height: 8.0),
              GestureDetector(
                onTap: onViewTap,
                child: Text(
                  'View',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFFA5A5A5),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
