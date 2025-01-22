import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/services/profile_service/profile_service.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import '../../../widgets/input_fields.dart';
import 'package:thrive_hub/core/utils/email_validator.dart'; // Import the file where emailValidator is defined.

class AccountSettingsScreen extends StatefulWidget {
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _fullNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();
  String profileImage='';
  bool _isFormModified = false;
  bool _isLoading = false; // Loading flag

  @override
  void initState() {
    super.initState();
    // Add listeners to detect changes
    _fullNameController.addListener(_onFieldChange);
    _dateController.addListener(_onFieldChange);
    _locationController.addListener(_onFieldChange);
    _emailController.addListener(_onFieldChange);
    _loadProfileData();

  }

  void _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    String fullName = prefs.getString('full_name') ?? '';
    String email = prefs.getString('email') ?? '';
    profileImage = prefs.getString('profile_image')??'';
    String city = prefs.getString('city') ?? '';
    setState(() {
      _emailController.text = email;
      _fullNameController.text = fullName;
    });
    // Attempt to load the profile data (if it's coming from an API or another source)
    final profileService = ProfileService();
    final profileData = await profileService.getProfile();
    // If the profile data is available and not empty, load it
    if (profileData != null && profileData.isNotEmpty) {
      await prefs.setString('profile_image', profileData['img_profile_url']?.toString() ?? '');
      setState(() {
       _fullNameController.text = profileData['full_name'] ?? '';
        _emailController.text = profileData['email'] ?? '';
        _locationController.text = profileData['address_city'] ?? '';
        _dateController.text = profileData['date_of_birth'] != null
            ? DateFormat('yyyy-MM-dd').format(DateTime.parse(profileData['date_of_birth']))
            : '';
        prefs.setString('city', profileData['address_city'] ?? '');
      });
    }
  }






  void _onFieldChange() {
    setState(() {
      _isFormModified = true;
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _isFormModified = true; // Update form modification state
      });
    }
  }

  Future<void> _validateAndSubmit() async {
    final email = _emailController.text.trim();
    final validationError = emailValidator(email);

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    // Collect form data
    final profileData = {
      "profileType": "personal",
      "profileData": {
        "date_of_birth": _dateController.text,
        "address_city": _locationController.text,
        "img_profile_url": profileImage ?? "",
      },
      "fullName": _fullNameController.text,
    };
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('city', _locationController.text);
    // Call the ProfileService to create the profile
    final profileService = ProfileService();
    await profileService.createAndUpdateProfile(profileData);
    await prefs.setString('full_name', profileData['fullName']?.toString() ?? '');
    setState(() {
      _isLoading = false; // Stop loading
    });

    // Handle successful submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profile updated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account Settings',
        showBackButton: true,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField(
                    labelText: 'First Name',
                    controller: _fullNameController,
                    labelColor: Color(0xFF5A5A5A),
                    labelFontSize: 14,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000),
                        offset: Offset(0, 1),
                        blurRadius: 11,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomInputField(
                        labelText: 'Date of Birth',
                        hintText: '01/01/2000',
                        controller: _dateController,
                        labelFontSize: 14,
                        labelColor: Color(0xFF5A5A5A),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1F000000),
                            offset: Offset(0, 1),
                            blurRadius: 11,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomInputField(
                    labelText: 'Location',
                    controller: _locationController,
                    labelFontSize: 14,
                    labelColor: Color(0xFF5A5A5A),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000),
                        offset: Offset(0, 1),
                        blurRadius: 11,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  CustomInputField(
                    labelText: 'Email',
                    hintText: 'mail.example@gmail.com',
                    controller: _emailController,
                    readOnly: true, // Add this to make the field non-editable
                    labelFontSize: 14,
                    labelColor: Color(0xFF5A5A5A),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000),
                        offset: Offset(0, 1),
                        blurRadius: 11,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormModified && !_isLoading ? _validateAndSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormModified && !_isLoading ? Colors.black : Color(0xFFA5A5A5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text(
                  'Continue',
                  style: TextStyle(
                    color: _isFormModified ? Colors.white : Color(0xFF000000),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
