import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/services/auth_services/logout_service.dart';  // Import the logout service


class BusinessProfileScreen extends StatefulWidget {
  @override
  _BusinessProfileScreenState createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  bool _isLoading = false;
  String _firstName = '';
  String _lastName = '';
  String _email = '';

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
        _email = userMap['email'] ?? '';
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                // Profile Image with Edit Icon
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/avtar.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_firstName.isNotEmpty || _lastName.isNotEmpty ? '$_firstName $_lastName' : 'Your Name'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.email, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            _email.isNotEmpty ? _email : 'gmail@example.com',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Edit Icon with Border
                // Edit Icon
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () {
                    // Add your edit functionality here
                  },
                ),
              ],
            ),
            SizedBox(height: 36),
            // Info Boxes with Background Color
            // Info Boxes Container with Background Color
            Container(
              width: 375,
              height: 90,
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8), // Padding inside the container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoBox('Reviews', '234'),
                  _buildInfoBox('Titel', '47'),
                  _buildInfoBox('Projects', '15'),
                ],
              ),
            ),

            SizedBox(height: 16),
            _buildListItem(context, Icons.business, 'Notification', Icons.arrow_forward_ios, '/business-notification'),
            _buildListItem(context, Icons.settings, 'Edit Account', Icons.arrow_forward_ios, '/business-account-settings'),
            _buildListItem(context, Icons.help, 'Help Center', Icons.arrow_forward_ios, '/business-help-center'),
            SizedBox(height: 16),
            _buildLogoutItem(context, Icons.logout, 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
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

        LogoutService logoutService = LogoutService();
        bool success = await logoutService.logout();

        setState(() {
          _isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Logout successful!'),
          ));

          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        } else {
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
