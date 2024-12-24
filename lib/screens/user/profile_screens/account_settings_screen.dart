import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:thrive_hub/services/profile_service/profile_service.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import '../../../widgets/input_fields.dart';
import 'package:thrive_hub/core/utils/email_validator.dart'; // Import the file where emailValidator is defined.

class AccountSettingsScreen extends StatefulWidget {
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isFormModified = false;
  bool _isLoading = false; // Loading flag

  @override
  void initState() {
    super.initState();
    // Add listeners to detect changes
    _firstNameController.addListener(_onFieldChange);
    _lastNameController.addListener(_onFieldChange);
    _dateController.addListener(_onFieldChange);
    _locationController.addListener(_onFieldChange);
    _emailController.addListener(_onFieldChange);
    _loadProfileData();
  }

  void _loadProfileData() async {
    final profileService = ProfileService();
    final profileData = await profileService.getProfile();

    if (profileData != null) {
      setState(() {
        // If full_name is null, use an empty string or some default value
        _firstNameController.text = profileData['full_name']?.split(' ').first ?? '';
        _lastNameController.text = profileData['full_name']?.split(' ').last ?? '';

        // Load other profile data with null checks
        _dateController.text = profileData['date_of_birth'] != null
            ? DateFormat('yyyy-MM-dd').format(DateTime.parse(profileData['date_of_birth']))
            : '';
        _locationController.text = profileData['address_line_1'] ?? '';
        _emailController.text = profileData['email'] ?? '';
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
    _firstNameController.dispose();
    _lastNameController.dispose();
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
        "occupation": "Software", // Add other required fields as necessary
        "date_of_birth": _dateController.text,
        "address_line_1": _locationController.text,
      }
    };

    // Call the ProfileService to create the profile
    final profileService = ProfileService();
    await profileService.createAndUpdateProfile(profileData);

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
                    controller: _firstNameController,
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
                  CustomInputField(
                    labelText: 'Last Name',
                    controller: _lastNameController,
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
