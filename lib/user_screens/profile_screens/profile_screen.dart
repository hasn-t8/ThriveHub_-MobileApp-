import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/services/auth_services/logout_service.dart';  // Import the logout service
import 'package:thrive_hub/user_screens/Welcome_screens/slider_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  String _firstName = '';
  String _lastName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('access_token');
    final expiresIn = prefs.getString('expires_in');

    print('Access Token: $accessToken');
    print('Expires In: $expiresIn');
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        _firstName = userMap['first_name'] ?? '';
        _lastName = userMap['last_name'] ?? '';
      });
    }
  }

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
                      image: AssetImage('assets/avtar.jpg'), // Replace with your image path
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
              '$_firstName $_lastName',
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
      onTap: () async {
        setState(() {
          _isLoading = true;
        });

        // Call the logout service
        LogoutService logoutService = LogoutService();
        bool success = await logoutService.logout();

        setState(() {

          _isLoading = false;
        });

        if (success) {
          // Show SnackBar on successful logout
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Logout successful!'),
          ));

          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } else {
          // Show SnackBar on failed logout
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Logout failed! Please try again.'),
          ));
        }
      },
      child: Container(
        width: 343,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(leadingIcon, size: 20, color: Color(0xFFFB0000)),
            SizedBox(width: 8),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFB0000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
