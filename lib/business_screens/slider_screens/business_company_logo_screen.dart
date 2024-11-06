import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BusinessCompanyLogoScreen extends StatefulWidget {
  final VoidCallback onNext;  // Callback to navigate to the next screen

  BusinessCompanyLogoScreen({required this.onNext});

  @override
  _BusinessCompanyLogoScreenState createState() => _BusinessCompanyLogoScreenState();
}

class _BusinessCompanyLogoScreenState extends State<BusinessCompanyLogoScreen> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {

        _image = image;
      });
    }
  }

  // Function to clear the selected image
  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  // Show options to pick an image from gallery or camera
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },

    );
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // Description Text
            Text(
              'Please upload your company logo with the required size: 266x200.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),

            // Upload Image Box
            Center(
              child: GestureDetector(
                onTap: _showImageSourceOptions,
                child: Container(
                  width: 266,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFFEFEFF0),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _image == null
                      ? Icon(
                    Icons.image_outlined,
                    color: Colors.grey,
                    size: 81,
                  )
                      : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(_image!.path),
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
            Spacer(), // Push the button to the bottom

            // Next Button
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                //add onPressed: _image !=null ?
                onPressed: _image == null ? widget.onNext : null, // Only enable if an image is selected
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF828282),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
