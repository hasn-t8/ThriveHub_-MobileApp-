import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/bottom_navigation_bar.dart';
import 'welcome_2.dart';


class Welcome1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4), // Set the background color
      body: Column(
        children: [
          // Top section with the first background color
          Container(
            color: Color(0xFFD8DADC),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 80.0, bottom: 6.0), // Adjusted padding
            child: Center(
              child: Text(
                'Choose your path',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Bottom section with the second background color
          Expanded(
            child: Container(
              color: Color(0xFFF4F4F4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),  // Add space between heading and container
                  Container(
                    width: 332,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F3F4),
                      borderRadius: BorderRadius.circular(8), // You can adjust the radius as needed
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Select the option that best suits your needs: create a business or discover and review products',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),  // Add space between container and image
                  Image.asset(
                    'assets/main.png',  // Ensure the image is placed in the assets folder
                    width: 143.61,
                    height: 124.41,
                  ),
                  SizedBox(height: 40),  // Add space between image and button
                  SizedBox(
                    width: 335,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your onPressed code here!
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => MainScreen()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Reduced corner radius
                        ),
                        minimumSize: Size(335, 50), // Fixed width
                      ),
                      child: Text(
                        'Discover Products',
                        style: TextStyle(
                          color: Colors.white, // Text color
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),  // Add space between buttons
                  Text(
                    'Go here to find the best products and leave reviews',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 30),  // Add space between text and button
                  SizedBox(
                    width: 335,
                    child: OutlinedButton(
                      onPressed: () {
                        // Add your onPressed code here!
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFD8DADC), width: 2), // Border color and width
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Reduced corner radius
                        ),
                        minimumSize: Size(335, 50), // Fixed width
                      ),
                      child: Text(
                        'Create a Business',
                        style: TextStyle(
                          color: Colors.black, // Text color
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),  // Add space between button and the final text
                  Text(
                    'Go here to create and manage your business',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
