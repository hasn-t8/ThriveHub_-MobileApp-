import 'package:flutter/material.dart';

class CreateReviewScreen extends StatefulWidget {
  @override
  _CreateReviewScreenState createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  int _selectedRating = 0;

  void _selectRating(int rating) {
    setState(() {
      _selectedRating = rating;
    });
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
      appBar: AppBar(
        title: Text('Create Review'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                height: 46,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    hintText: 'Enter company name',
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Rate your previous experience',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    hintText: 'Type your review...',
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Icon(Icons.photo_camera),
                  SizedBox(width: 8.0),
                  Text(
                    'Attach a photo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle done action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA5A5A5), // Button color
                  ),
                  child: Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}