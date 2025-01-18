import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thrive_hub/core/constants/text_styles.dart';
import 'package:thrive_hub/core/utils/image_picker.dart';
import 'package:thrive_hub/core/utils/thank_you.dart';
import 'package:thrive_hub/screens/business/widgets/description_bottom_sheet.dart';
import 'package:thrive_hub/screens/business/widgets/edit_account_form.dart';
import 'package:thrive_hub/services/profile_service/profile_service.dart';
import 'package:thrive_hub/widgets/appbar.dart';

class BusinessAccountScreen extends StatefulWidget {
  @override
  _BusinessAccountScreenState createState() => _BusinessAccountScreenState();
}

class _BusinessAccountScreenState extends State<BusinessAccountScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneCodeController = TextEditingController(text: "+1213");
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _description;
  File? _selectedImage;
  bool _isDataUpdated = false; // Tracks if data is updated
  bool _isLoading = false; // Tracks if API call is in progress

  final ProfileService _apiService = ProfileService();

  @override
  void initState() {
    super.initState();
    _fetchBusinessDetails();

    // Add listeners to detect changes in input fields
    _companyNameController.addListener(_markDataAsUpdated);
    _websiteController.addListener(_markDataAsUpdated);
    _phoneCodeController.addListener(_markDataAsUpdated);
    _phoneController.addListener(_markDataAsUpdated);
    _emailController.addListener(_markDataAsUpdated);
    _descriptionController.addListener(_markDataAsUpdated);
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _companyNameController.dispose();
    _websiteController.dispose();
    _phoneCodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Marks data as updated when any input field changes
  void _markDataAsUpdated() {
    setState(() {
      _isDataUpdated = true;
    });
  }

  /// Fetch business details from the API
  Future<void> _fetchBusinessDetails() async {
    try {
      final data = await _apiService.fetchBusinessDetails();
      setState(() {
        _companyNameController.text = data['org_name'] ?? '';
        _websiteController.text = data['business_website_url'] ?? '';
        _phoneCodeController.text = data['phoneCode'] ?? '+234';
        _phoneController.text = data['phone'] ?? '';
        _emailController.text = data['work_email'] ?? '';
        _description = data['about_business'] ?? '';

        // Initialize _descriptionController with the fetched description
        _descriptionController.text = _description ?? '';
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load business details')),
      );
    }
  }

  /// Update profile data only
  Future<void> _updateProfileData() async {
    final updatedData = {
      'profileData': {
        'org_name': _companyNameController.text,
        'business_website_url': _websiteController.text,
        'work_email': _emailController.text,
        'about_business': _description,
      },
    };

    try {
      // Call the API and capture the success status
      final isSuccessful = await _apiService.UpdateBusinessProfile(updatedData);

      if (isSuccessful) {
        // Show the Thank You popup
        ThankYou.show(context);

      } else {
        // Show an error message if the update failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update business details')),
        );
      }
    } catch (error) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating business details: $error')),
      );
    }
  }


  /// Update profile image only
  Future<void> _updateProfileImage() async {
    if (_selectedImage == null) return; // Exit if no image is selected

    try {
      bool isSuccess = await _apiService.businessUploadLogo(_selectedImage!);

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile image. Please try again.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading profile image: $error')),
      );
    }
  }

  /// Save description
  void _saveDescription(String description, File? selectedImage) {
    setState(() {
      _description = description;
      _descriptionController.text = description; // Update the controller
      _selectedImage = selectedImage;
      _isDataUpdated = true; // Mark data as updated
    });

  }

  /// Check for changes and update API
  Future<void> _updateBusinessDetails() async {
    if (_isDataUpdated) {
      setState(() {
        _isLoading = true; // Show loader
      });

      try {
        await _updateProfileData(); // Update profile data
        await _updateProfileImage(); // Update profile image

        setState(() {
          _isLoading = false; // Hide loader
          _isDataUpdated = false; // Reset update flag
        });
      } catch (error) {
        setState(() {
          _isLoading = false; // Hide loader
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update details. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No changes to update')),
      );
    }
  }


  /// Show the description bottom sheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ReusableBottomSheet(
          descriptionController: _descriptionController,
          onSave: _saveDescription,
          initialSelectedImage: _selectedImage,
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: 'Business Account',
        showBackButton: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccountForm(
              companyNameController: _companyNameController,
              websiteController: _websiteController,
              phoneCodeController: _phoneCodeController,
              phoneController: _phoneController,
              emailController: _emailController,
            ),
            SizedBox(height: 8),
            if (_description != null && _description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About Company",
                      style: bHeadingTextStyle.copyWith(color: Color(0xFF5A5A5A)),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showBottomSheet(context),
                      child: Container(
                        height: 152,
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFBFBFB),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF000000).withOpacity(0.12),
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          _description!,
                          style: bReviewTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: [
                    Text(
                      "Your company does not have a description yet. Add to improve user trust",
                      textAlign: TextAlign.center,
                      style: bDescriptionTextStyle,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showBottomSheet(context),
                      child: Text("Add Description"),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _isDataUpdated && !_isLoading ? _updateBusinessDetails : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text(
                  "Update Profile",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
