import 'package:flutter/material.dart';

class SubCategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      height: 396, // Specified height
      color: Color(0xFFFFFFFF), // Background color #FFFFFF
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Heading', // Replace with your heading text
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  // Handle "See All" tap here
                },
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue, // Customize color if needed
                      ),
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.blue, // Customize color if needed
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16), // Space between header and box below

          // Box below the header
          Container(
            width: 131, // Fixed width
            height: 117, // Fixed height
            padding: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Color(0xFFE9E8E8), // Background color #E9E8E8
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Subheading', // Replace with your subheading text
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF414141),
                  height: 22 / 14, // Line height ratio
                  letterSpacing: -0.41,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
