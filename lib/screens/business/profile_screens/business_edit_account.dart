import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thrive_hub/core/constants/text_styles.dart';
import 'package:thrive_hub/core/utils/image_picker.dart';
import 'package:thrive_hub/core/utils/thank_you.dart';
import 'package:thrive_hub/screens/business/widgets/description_bottom_sheet.dart';
import 'package:thrive_hub/screens/business/widgets/edit_account_form.dart';
import 'package:thrive_hub/services/profile_service/profile_service.dart';
import 'package:thrive_hub/widgets/alert_box.dart';
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

  final ProfileService _apiService = ProfileService();

  @override
  void initState() {
    super.initState();
    _fetchBusinessDetails();
  }

  Future<void> _fetchBusinessDetails() async {
    try {
      final data = await _apiService.fetchBusinessDetails();
      setState(() {
        _companyNameController.text = data['companyName'] ?? '';
        _websiteController.text = data['website'] ?? '';
        _phoneCodeController.text = data['phoneCode'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _emailController.text = data['email'] ?? '';
        _description = data['description'] ?? '';
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load business details')),
      );
    }
  }

  Future<void> _updateBusinessDetails() async {
    try {
      final data = {
        'companyName': _companyNameController.text,
        'website': _websiteController.text,
        'phoneCode': _phoneCodeController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'description': _description,
      };

      await _apiService.createAndUpdateProfile(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Business details updated successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update business details')),
      );
    }
  }

  void _saveDescription(String description, File? selectedImage) {
    setState(() {
      _description = description;
      _selectedImage = selectedImage;
    });
    ThankYou.show(context);
  }

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
                      style:
                      bHeadingTextStyle.copyWith(color: Color(0xFF5A5A5A)),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: GestureDetector(
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
                    ),
                    SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: GestureDetector(
                        onTap: () => _showBottomSheet(context),
                        child: Text(
                          'Show more',
                          style: bReviewTextStyle.copyWith(
                            color: Color(0xFF979797),
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF979797),
                          ),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Color(0xFFD8DADC)),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        "Add Description",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
