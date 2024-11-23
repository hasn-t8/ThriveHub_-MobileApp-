import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thrive_hub/core/constants/text_styles.dart';
import 'package:thrive_hub/core/utils/image_picker.dart';
import 'package:thrive_hub/screens/business/widgets/edit_account_form.dart';
import 'package:thrive_hub/widgets/alert_box.dart';
import 'package:thrive_hub/widgets/appbar.dart';

class BusinessAccountScreen extends StatefulWidget {
  @override
  _BusinessAccountScreenState createState() => _BusinessAccountScreenState();
}

class _BusinessAccountScreenState extends State<BusinessAccountScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneCodeController =
  TextEditingController(text: "+1213");
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _description;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _fetchDescription();
  }

  Future<void> _handleAttachPhoto(BuildContext context) async {
    try {
      final File? image = await pickImageWithUI(context);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        print("Selected image path: ${_selectedImage?.path}");
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }


  void _removeSelectedImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _fetchDescription() async {
    // Simulate a database fetch
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _description = ""; // Replace with fetched value, e.g., from API or database
    });
  }

  void _saveDescription(String description) {
    setState(() {
      _description = description;
    });
    // Save the description to the database here
  }

  void _showBottomSheet(BuildContext context) {
    _descriptionController.text = _description ?? "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(),
                        Text(
                          'Edit Description',
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: CircleAvatar(
                            radius: 8.5,
                            backgroundColor: Color(0xFF8E8E93),
                            child: Icon(Icons.close, size: 17, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 20),
                    Container(
                      width: 341,
                      height: 154,
                      padding: EdgeInsets.all(10),
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
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: 'Type your Description here...',
                          hintStyle:bReviewTextStyle,
                          border: InputBorder.none,
                        ),
                        style: bReviewTextStyle, // Style for the input text
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: () async {
                        final image = await pickImageWithUI(context);
                        if (image != null) {
                          setState(() {
                            _selectedImage = image;
                          });
                          setModalState(() {}); // Update the bottom sheet UI
                        }
                      },
                      icon: Icon(Icons.attach_file, color: Color(0xFFB3B3B3)),
                      label: Text(
                        "Attach Photo",
                        style: TextStyle(color: Color(0xFFB3B3B3)),
                      ),
                    ),
                    // SizedBox(height: 16),
                    if (_selectedImage != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${_selectedImage!.path.split('/').last}',
                              style: TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                              setModalState(() {}); // Update the bottom sheet UI
                            },
                          ),
                        ],
                      ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _saveDescription(_descriptionController.text);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertBox(
                              imagePath: 'assets/main.png',
                              title: 'Thank You!',
                              message: 'Your description will appear on the page shortly.',
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        "Save",
                        style: kButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Ensures screen adjusts when the keyboard appears
      appBar: CustomAppBar(
        title: 'Business Account',
        showBackButton: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Makes the screen scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns left content
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
                  padding: const EdgeInsets.fromLTRB(16,0,16,0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(
                        "About Company",
                        style: bHeadingTextStyle.copyWith(color: Color(0xFF5A5A5A)),
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
                            decoration:BoxDecoration(
                              color: Color(0xFFFBFBFB), // Background color of the box
                              borderRadius: BorderRadius.circular(16), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF000000).withOpacity(0.12), // Shadow color with opacity
                                  blurRadius: 10, // The blur radius of the shadow
                                  offset: Offset(0, 1), // The offset of the shadow
                                ),
                              ],
                            ),
                            child: Text(
                              _description!,
                              style: bReviewTextStyle, // Style for the input text,
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
                  padding: const EdgeInsets.fromLTRB(16,0,16,0),
                  child: Column(
                    children: [
                      Text(
                        "Your company does not have a description yet. Add to improve user trust",
                        textAlign: TextAlign.center,
                        style:bDescriptionTextStyle
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
                          style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.w500),
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
