//imports
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final String location;
  final String timeAgo;
  final String reviewerName;
  final String reviewText;
  final int likes;
  final VoidCallback onLike;
  final VoidCallback onShare;

  ReviewCard({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.location,
    required this.timeAgo,
    required this.reviewerName,
    required this.reviewText,
    required this.likes,
    required this.onLike,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0), // Full screen width
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 4, // Add shadow
      color: Color(0xFFF1F3F4), // Match the background color
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFFF1F3F4), // Match the screen background color
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
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
                  backgroundImage: NetworkImage(imageUrl),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          Icon(Icons.star, color: Color(0xFF4D4D4D), size: 18.0),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.black, size: 16.0),
                        SizedBox(width: 4.0),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 14.0,

                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                // Handle reviewer name tap
              },
              child: Text(
                reviewerName,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              reviewText,
              style: TextStyle(
                fontSize: 12.0,
                // color: Colors.black,
                color: Color(0xFF777777),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onLike,
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: Color(0xFF434242)), // Change heart color here
                      SizedBox(width: 4.0),
                      Text(likes.toString()),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                GestureDetector(
                  onTap: onShare,
                  child: Icon(Icons.share_outlined, color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}