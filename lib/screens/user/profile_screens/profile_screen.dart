import 'dart:convert';
import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/services/auth_services/auth_service.dart';
import 'package:thrive_hub/services/profile_service/profile_service.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/profile_listitem.dart'; // Import the reusable widget

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  String _full_name = '';
  String _location = '';
  int _reviews = 0; // Default value for reviews
  int _companyCount = 0; // Default value for company count
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> uploadProfileImage() async {
    if (_imageFile == null) {
      print("No image selected.");
      return;
    }

    try {
      final profileService = ProfileService(); // Create an instance
      final response = await profileService.uploadImage(_imageFile!.path);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image uploaded successfully!'), backgroundColor: Colors.green),
        );
      } else {
        print('Failed to upload image: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload profile image.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading profile image: $e')),
      );
    }
  }



  void _removeLogo() {
    setState(() {
      _imageFile = null; // Clear the selected image
    });
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
                    await uploadProfileImage(); // Upload the new image
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
                    await uploadProfileImage(); // Upload the new image
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

    // Retrieve the access token
    final accessToken = prefs.getString('access_token');
    print('Access Token in profile: $accessToken');

    // Use default values if the retrieved values are null
    final fullName = prefs.getString('full_name') ?? 'Name'; // Default value for full name
    final profileImage = prefs.getString('profile_image');
    final location = prefs.getString('city') ?? 'Location'; // Default if null
    final reviews = prefs.getInt('reviews') ?? 28; // Default value for reviews
    final companyCount = prefs.getInt('company_count') ?? 38; // Default value for company count

    // Optionally, print the retrieved data to verify
    print('Full Name : $fullName');
    print('Profile Image: $profileImage');
    print('Location: $location');
    print('Reviews: $reviews');
    print('Company Count: $companyCount');

    // Update the UI fields with the retrieved data
    setState(() {
      // Set fields with the retrieved values, default to empty strings or null if not found
      _full_name = fullName;
      _location = location;
      _reviews = reviews; // Set default reviews count
      _companyCount = companyCount; // Set default company count

      // If there's a profile image in SharedPreferences, set it
      if (profileImage != null) {
        _imageFile = File(profileImage); // Set the profile image from SharedPreferences
      }
    });
  }

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    AuthService logoutService = AuthService();
    final result = await logoutService.logout();

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result['message']),
    ));

    if (result['success']) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
      backgroundColor: Color(0xFFFCFCFC),
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
            SizedBox(height: 6),
            GestureDetector(
              onTap: _removeLogo, // Define the action for removing the logo
              child: Text(
                'Remove logo',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFA5A5A5),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(height: 12),
            // Name and Location
            Text(
              '$_full_name',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$_location', // Use the location from the state variable
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
              padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
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
                Navigator.pushNamed(context, '/account-settings').then((_) {
                  setState(() {
                    _loadUserData();
                  });
                });
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
