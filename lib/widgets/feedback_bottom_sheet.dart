import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/alert_box.dart';

class FeedbackBottomSheet extends StatefulWidget {
  final String business_profile_id;
  final String companyTitle;

  FeedbackBottomSheet({required this.business_profile_id,required this.companyTitle});

  @override
  _FeedbackBottomSheetState createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  int selectedFaceIndex = -1;
  final TextEditingController reviewController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;
  bool isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImage = image;
        });
      }
    } catch (e) {
      print("Error selecting image: $e");
    }
  }

  Future<void> _submitFeedback() async {
    if (selectedFaceIndex == -1) {
      // Show a message if no face is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a face for your rating')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final CompanyService apiService = CompanyService(); // Replace with your API service
      final String businessId = widget.business_profile_id; // Replace with actual business logic
      final int rating = (selectedFaceIndex + 1) * 2; // Calculate rating based on face selection

      final bool isSuccess = await apiService.createReview(
        businessId: businessId,
        rating: rating,
        feedback: reviewController.text,
      );

      if (isSuccess) {
        Navigator.pop(context);
        Navigator.of(context).pop();

        // Show custom alert dialog
        showDialog(
          context: context,
          builder: (context) => CustomAlertBox(
            imagePath: 'assets/logo.png',
            title: 'Thank You!',
            message: 'Your feedback is important to us and makes us better!',
            name: '', // Optional
          ),
        );
      } else {
        // Show SnackBar for failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submission failed.')),
        );
      }
    } catch (e) {
      // Show SnackBar for error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please try again later.')),
      );
      print('Error submitting feedback: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Text(
                  'Feedback',
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
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
            SizedBox(height: 8),
            Divider(color: Colors.grey, thickness: 1.0, height: 4.0),
            SizedBox(height: 16),
            Text(
              'How was your experience with ${widget.companyTitle}?',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: 20),
            ),
            SizedBox(height: 16),
            if (selectedFaceIndex != -1)
              Text(
                faceLabels[selectedFaceIndex],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(faces.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFaceIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: selectedFaceIndex == index
                              ? Color(0x33FFC700)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          faces[index],
                          size: 44,
                          color: selectedFaceIndex == index
                              ? Color(0xFFFFC700)
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            Container(
              width: 341,
              height: 154,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFFBFBFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: reviewController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Type your review here...',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            if (selectedImage != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(File(selectedImage!.path)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = null;
                      });
                    },
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(343, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
