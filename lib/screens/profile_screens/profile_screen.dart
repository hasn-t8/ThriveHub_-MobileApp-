import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        showBackButton: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image with Edit Icon
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 98,
                  height: 98,
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/profile_image.png'), // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Name and Location
            Text(
              'Name Surname',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Location',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            // Information Box
            Container(
              width: 393,
              decoration: BoxDecoration(
                color: Color(0xFFE9E8E8),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoBox('Reviews \n234'),
                  _buildInfoBox('Company\n47'),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Clickable List Items
            _buildListItem(context, Icons.business, 'My Companies', Icons.arrow_forward_ios, '/my-companies'),
            _buildListItem(context, Icons.settings, 'Account Settings', Icons.arrow_forward_ios, '/account-settings'),
            _buildListItem(context, Icons.help, 'Help Center', Icons.arrow_forward_ios, '/help-center'),
            SizedBox(height: 16), // Add space before the Logout button
            _buildLogoutItem(context, Icons.logout, 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(8.0), // Reduced padding
        margin: const EdgeInsets.symmetric(horizontal: 19.0),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14, // Reduced font size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, IconData leadingIcon, String text, IconData trailingIcon, String routeName) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        width: 343,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(leadingIcon, size: 20),
                SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Icon(trailingIcon, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context, IconData leadingIcon, String text) {
    return InkWell(
      onTap: () {
        // Handle logout
      },
      child: Container(
        width: 343,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(
          //   color: Colors.grey,
          //   width: 1.0,
          // ),
        ),
        child: Row(
          children: [
            Icon(leadingIcon, size: 20, color: Color(0xFFFB0000)),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFFB0000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
