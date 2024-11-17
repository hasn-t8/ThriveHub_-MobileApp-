import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/input_fields.dart';
import 'package:image_picker/image_picker.dart';

class CreateReviewScreen extends StatefulWidget {
  @override
  _CreateReviewScreenState createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final _companyNameController = TextEditingController();
  int _selectedRating = 0;
  File? _selectedImage; // To store the selected image

  void _selectRating(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }
  List<String> _allCompanies = [
    'Apple',
    'Google',
    'Amazon',
    'Microsoft',
    'Tesla',
  ]; // Mock list of company names
  List<String> _filteredCompanies = [];

  @override
  void initState() {
    super.initState();

    // Add listener to update the dropdown list
    _companyNameController.addListener(() {
      final query = _companyNameController.text.toLowerCase();
      setState(() {
        _filteredCompanies = _allCompanies
            .where((company) => company.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    List<IconData> faces = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];

    List<String> faceLabels = [
      'Angry!',
      'Disappointed!',
      'Neutral!',
      'Satisfied!',
      'Very Happy!',
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create review',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputField(
                  labelText: 'Campany Name',
                  controller: _companyNameController,
                  labelFontSize: 14, // Custom label font size
                ),

                SizedBox(height: 16.0),
                Text(
                  'Rate your previous experience',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1E1E1E),
                    fontFamily: 'Inter', // Set the font family to 'Inter'
                    fontWeight: FontWeight.w500,
                    height: 20 / 14,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(faces.length, (index) {
                    return GestureDetector(
                      onTap: () => _selectRating(index + 1),
                      child: Column(
                        children: [
                          Icon(
                            faces[index],
                            color: _selectedRating == index + 1
                                ? Colors.amber
                                : Colors.grey,
                            size: 44, // Icon size
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: 16.0),
                if (_selectedRating > 0) // Check if a rating is selected
                  Center(
                    child: Text(
                      faceLabels[_selectedRating - 1], // Display the selected rating label
                      style: TextStyle(
                        fontSize: 20, // font size
                        fontWeight: FontWeight.w500, // font weight 500
                        height: 1.4, // equivalent to line-height (28px / 20px)
                        letterSpacing: 0.592, // letter spacing
                        fontFamily: 'SF Pro Display', // custom font family
                        textBaseline: TextBaseline.alphabetic, // ensures alignment
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
                Container(
                  width: 341.0, // Fixed width
                  padding: const EdgeInsets.only(top: 10.0), // Padding
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBFBFB), // Background color
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1F000000), // Shadow color with transparency
                        offset: const Offset(0, 1), // Shadow position
                        blurRadius: 10.0, // Shadow blur radius
                      ),
                    ],
                  ),
                  child: TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        borderSide: BorderSide.none, // Removes visible border
                      ),
                      hintText: 'Type your review...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Inter', // Font family
                        fontSize: 16, // Font size
                        fontWeight: FontWeight.w500, // Font weight
                        height: 22 / 16, // Line height calculation
                        letterSpacing: -0.41, // Letter spacing
                        color: Color(0xFFb1b1b1), // Hint text color
                      ),
                      contentPadding: const EdgeInsets.all(16.0), // Inner padding
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/upload_image.png', // Replace with your upload icon
                        width: 16,
                        height: 16,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Attach a photo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFA5A5A5),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedImage != null) ...[
                  SizedBox(height: 16.0), // Add spacing between text and image
                  Stack(
                    children: [
                      Image.file(
                        _selectedImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: _removeImage,
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 80.0), // Extra spacing to account for the button
              ],
  ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity, // Makes the button span the full width
                child: ElevatedButton(
                  onPressed: () {
                    // Handle done action
                    Navigator.pop(context); // Close the current screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA5A5A5), // Button color
                    padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 19),
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                      side: const BorderSide(color: Color(0xFFA5A5A5), width: 1), // Border
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontFamily: 'Inter', // Font family
                      fontSize: 16, // Font size
                      fontWeight: FontWeight.w500, // Font weight
                      height: 1.25, // Line height (20px / 16px)
                      color: Color(0xFF000000), // Text color
                      textBaseline: TextBaseline.alphabetic, // Alignment
                    ),
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