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
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> uploadProfileImage() async {
    if (_imageFile == null || _imageFile!.path.isEmpty) {
      print("No valid image selected.");
      return;
    }

    try {
      final profileService = ProfileService(); // Create an instance
      final response = await profileService.uploadImage(_imageFile!.path);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract URL from the response
        final imageUrl = responseData['url'];
        // Save the URL to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image', imageUrl);
        await _loadUserData();
        setState(() {
          _profileImageUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile image uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Failed to upload image: ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload profile image.'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading profile image: $e'),
        ),
      );
    }
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

    final fullName = prefs.getString('full_name') ?? 'Name';
    final profileImage = prefs.getString('profile_image'); // Retrieve profile image URL
    final location = prefs.getString('city') ?? '';
    final reviews = prefs.getInt('reviews') ?? 0;
    final companyCount = prefs.getInt('company_count') ?? 0;

    setState(() {
      _full_name = fullName;
      _location = location;
      _reviews = reviews;
      _companyCount = companyCount;
      _profileImageUrl = profileImage; // Assign URL or null
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
      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['message']),
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
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 98,
                    height: 98,
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _imageFile != null
                            ? FileImage(_imageFile!) // Use local file
                            : (_profileImageUrl != null && _profileImageUrl!.isNotEmpty
                            ? NetworkImage(_profileImageUrl!) // Use URL
                            : AssetImage('assets/avtar.jpg') as ImageProvider), // Default avatar
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFD9D9D9),
                      child: Image.asset(
                        'assets/edit_profile.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              _full_name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              _location,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA5A5A5),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 343,
              height: 104,
              decoration: BoxDecoration(
                color: Color(0xFFE9E8E8),
                borderRadius: BorderRadius.circular(31),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoBox('Reviews\n$_reviews'),
                  _buildInfoBox('Company\n$_companyCount'),
                ],
              ),
            ),
            SizedBox(height: 16),
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
            ProfileListItem(
              leadingIcon: Icons.logout,
              border: Border.all(color: Color(0xFFFBFBFB)),
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
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
