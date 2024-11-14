import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thrive_hub/widgets/alert_box.dart';

class FeedbackBottomSheet extends StatefulWidget {
  final String companyTitle;

  FeedbackBottomSheet({required this.companyTitle});

  @override
  _FeedbackBottomSheetState createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  int selectedFaceIndex = -1;
  final TextEditingController reviewController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;

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
            // Heading with close button
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
                    letterSpacing: -0.5,
                    decoration: TextDecoration.underline,
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
            Divider(),

            // Instruction text
            SizedBox(height: 16),
            Text(
              'How was your experience with ${widget.companyTitle}?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16),

            // Selected face label text (above the faces row)
            if (selectedFaceIndex != -1)
              Text(
                faceLabels[selectedFaceIndex],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.592,
                  decoration: TextDecoration.underline,
                ),
              ),
            SizedBox(height: 16),

            // Face icons
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
                              ? Color(0x33FFC700) // 20% opacity
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          boxShadow: selectedFaceIndex == index
                              ? [
                            BoxShadow(
                              color: Color(0xFF000000).withOpacity(0.12),
                              blurRadius: 10,
                            )
                          ]
                              : [],
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

            // Review text box
            Container(
              width: 341,
              height: 154,
              padding: EdgeInsets.all(10),
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

            // Attach photo and button
            GestureDetector(
              onTap: _pickImage,
              child: Row(
                children: [
                  Icon(Icons.photo_camera, size: 24, color: Colors.black),
                  SizedBox(width: 8),
                  Text(
                    'Attach photo',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
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
                        selectedImage = null; // Clear the selected image
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

            // Done button
            ElevatedButton(
              onPressed: () {
                print('Feedback submitted');
                print('Selected face: ${faceLabels[selectedFaceIndex]}');
                print('Review: ${reviewController.text}');
                print('Selected Image: ${selectedImage?.path}');
                Navigator.pop(context); // Close the bottom sheet
                // Show custom alert dialog
                showDialog(
                context: context,
                builder: (context) => CustomAlertBox(
                imagePath: 'assets/main.png', // Replace with your image path or leave null
                title: 'Thank You!',
                message: 'Your feedback is important to us and makes us better!',
                  name: 'Alex', // Optional
                ),
                );
              },
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
                  fontWeight: FontWeight.w400,
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

// Usage: Show the bottom sheet with a company title
void showFeedbackBottomSheet(BuildContext context, String companyTitle) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => FeedbackBottomSheet(companyTitle: companyTitle),
  );
}
