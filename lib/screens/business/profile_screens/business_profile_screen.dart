import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:thrive_hub/screens/business/widgets/profile_section.dart';
import 'package:thrive_hub/widgets/profile_listitem.dart';

class BusinessProfileScreen extends StatefulWidget {
  @override
  _BusinessProfileScreenState createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  bool _isLoading = false;

  int reviewsCount = 234;
  int titleCount = 47;
  int projectsCount = 15;

  List<Map<String, String>> get infoBoxes => [
    {'title': '$reviewsCount' , 'subtitle': 'Reviews'},
    {'title':'$titleCount' , 'subtitle':'Title' },
    {'title': '$projectsCount' , 'subtitle': 'Projects'},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ProfileSection(
              firstName: _firstName,
              lastName: _lastName,
              email: _email,
              profileImagePath: 'assets/avtar.jpg',
              onEditProfile: () {
                // Handle profile edit functionality
              },
              infoBoxes: infoBoxes, // Pass the dynamically generated list
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(0), // Remove padding for the list items
              children: [
                ProfileListItem(
                  leadingIcon: Icons.business,
                  text: 'Notification',
                  trailingIcon: Icons.arrow_forward_ios,
                  onTap: () {
                    Navigator.pushNamed(context, '/business-notification');
                  },
                ),
                ProfileListItem(
                  leadingIcon: Icons.settings,
                  text: 'Edit Account',
                  trailingIcon: Icons.arrow_forward_ios,
                  onTap: () {
                    Navigator.pushNamed(context, '/business-account-settings');
                  },
                ),
                ProfileListItem(
                  leadingIcon: Icons.help,
                  text: 'Help Center',
                  trailingIcon: Icons.arrow_forward_ios,
                  onTap: () {
                    Navigator.pushNamed(context, '/business-help-center');
                  },
                ),
                const SizedBox(height: 16),
                ProfileListItem(
                  leadingIcon: Icons.logout,
                  text: _isLoading ? 'Logging out...' : 'Logout',
                  onTap: () {
                    Navigator.pushNamed(context, '/business-sign-in');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
