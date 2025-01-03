import 'package:flutter/material.dart';
import 'package:thrive_hub/core/utils/image_picker.dart';
import '../../../core/constants/text_styles.dart';
import 'dart:io';

class BusinessCompanyLogoScreen extends StatefulWidget {
  final VoidCallback onNext;
  final Function(String) onLogoSelected; // Changed to accept a String (file path)

  BusinessCompanyLogoScreen({
    required this.onNext,
    required this.onLogoSelected,
  });

  @override
  _BusinessCompanyLogoScreenState createState() => _BusinessCompanyLogoScreenState();
}

class _BusinessCompanyLogoScreenState extends State<BusinessCompanyLogoScreen> {
  File? _image;

  void _onImageIconPressed() async {
    File? selectedImage = await pickImageWithUI(context);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
        widget.onLogoSelected(selectedImage.path); // Send the file path as a String
      });
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              'Add Your Company Logo',
              style: bHeadingTextStyle,
            ),
            SizedBox(height: 16),

            // Description Text
            Text(
              'Please upload your company logo with the required size: 266x200.',
              style: bDescriptionTextStyle,
            ),
            SizedBox(height: 32),

            // Upload Image Box
            Center(
              child: GestureDetector(
                onTap: _onImageIconPressed,
                child: Container(
                  width: 266,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFEFEFF0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _image == null
                      ? Center(
                    child: SizedBox(
                      width: 81,
                      height: 81,
                      child: Image.asset(
                        'assets/category.png', // Replace with your image path
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        color: Colors.grey,
                      ),
                    ),
                  )
                      : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: GestureDetector(
                          onTap: _clearImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.red.withOpacity(0.7),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _image != null ? widget.onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF828282),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Next',
                  style: kButtonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
