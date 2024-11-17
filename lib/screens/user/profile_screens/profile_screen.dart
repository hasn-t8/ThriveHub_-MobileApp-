import 'dart:convert';
import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/services/auth_services/logout_service.dart';
import 'package:thrive_hub/widgets/profile_listitem.dart'; // Import the reusable widget

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  String _firstName = '';
  String _lastName = '';
  String _location = 'Location'; // Default value for location
  int _reviews = 0; // Default value for reviews
  int _companyCount =0; // Default value for company count
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  Future<void> _pickImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context); // Close the dialog
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close the dialog
                  final ImagePicker picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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
        _location = userMap['location'] ?? 'location';
        _reviews = userMap['reviews'] ?? 35;
        _companyCount = userMap['company_count'] ?? 47;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
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
                // Profile Image
                // Profile Image
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 98,
                    height: 98,
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                      image: _imageFile != null
                          ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover, // Ensure the image fills the circle properly
                      )
                          : DecorationImage(
                        image: AssetImage('assets/avtar.jpg'), // Default avatar
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Edit Icon
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFD9D9D9),
                      child: Image.asset(
                        'assets/edit_profile.png', // Replace with your image icon
                        width: 20,
                        height: 20,
                      ),
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
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              _location, // Use the location from the state variable
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA5A5A5),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10),
            // Information Box
            Container(
              width: 343,
              height: 104,
              decoration: BoxDecoration(
                color: Color(0xFFE9E8E8),
                borderRadius: BorderRadius.circular(31),
              ),
              padding: const EdgeInsets.only(top:20.0,left: 20.0,right: 20.0,bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoBox('Reviews\n$_reviews'), // Use reviews
                  _buildInfoBox('Company\n$_companyCount'), // Use company count
                ],
              ),
            ),
            SizedBox(height: 16),
            // Clickable List Items
            ProfileListItem(
              leadingIcon: Icons.business,
              text: 'My Companies',
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                Navigator.pushNamed(context, '/my-companies');
              },
            ),
            ProfileListItem(
              leadingIcon: Icons.settings,
              text: 'Account Settings',
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                Navigator.pushNamed(context, '/account-settings');
              },
            ),
            ProfileListItem(
              leadingIcon: Icons.help,
              text: 'Help Center',
              trailingIcon: Icons.arrow_forward_ios,
              onTap: () {
                Navigator.pushNamed(context, '/help-center');
              },
            ),
            SizedBox(height: 16),
            // Logout Button
            ProfileListItem(
              leadingIcon: Icons.logout,
              border: Border.all(color: Color(0xFFFBFBFB)), // Custom border
              text: _isLoading ? 'Logging out...' : 'Logout',
              leadingIconColor: Color(0xFFFB0000),
              textColor: Color(0xFFFB0000),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000),
              offset: Offset(0, 1),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(4.0),

        margin: const EdgeInsets.symmetric(horizontal: 19.0),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}