import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String serviceName;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String location;
  final VoidCallback onWriteReview;
  final VoidCallback onTryService;
  final bool showWriteReviewButton;
  final bool showTryServiceButton;
  final String writeReviewText;
  final String tryServiceText;

  const ServiceCard({
    Key? key,
    required this.serviceName,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.onWriteReview,
    required this.onTryService,
    this.showWriteReviewButton = true, // Default to show Write Review button
    this.showTryServiceButton = true,  // Default to show Try Service button
    this.writeReviewText = 'Write a Review', // Default text for Write Review button
    this.tryServiceText = 'Try Service', // Default text for Try Service button
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: double.infinity,
      height: 270.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.transparent,
      ),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 128.0,
              padding: EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  Container(
                    width: 90.0,
                    height: 96.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(0),
                      ),
                      color: Color(0xFFEFEFEF),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 13.0),
                  Expanded(
                    child: Container(
                      height: 96.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceName,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.35,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            children: [
                              Text('$rating', style: TextStyle(color: Color(0xFF888686))),
                              Icon(Icons.star, color: Color(0xFF888686)),
                              SizedBox(width: 8.0),
                              Text('|', style: TextStyle(color: Color(0xFFA5A5A5))),
                              SizedBox(width: 8.0),
                              Text('$reviewCount Reviews', style: TextStyle(color: Color(0xFF888686))),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: Color(0xFF4D4D4D)),
                              Text(
                                location,
                                style: TextStyle(
                                  color: Color(0xFFA5A5A5), // Text color
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline, // Adds underline
                                  decorationColor: Color(0xFFA5A5A5), // Underline color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            // Conditionally render Write Review button
            if (showWriteReviewButton)
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 300),
                child: Container(
                  width: 343.0,
                  height: 54.0,
                  padding: EdgeInsets.symmetric(vertical: 17.0, horizontal: 19.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: onWriteReview,
                    child: Center(
                      child: Text(
                        writeReviewText,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter', // Set the font family to 'Inter'
                          fontSize: 16,        // Set the font size to 16px
                          fontWeight: FontWeight.w500, // Set font weight to 500
                          height: 1.25, // Set line height (1.25 equals 20px for 16px font size)
                          decoration: TextDecoration.none, // Remove text underline
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Conditionally render Try Service button
            if (showTryServiceButton)
              SizedBox(height: 10.0),
            if (showTryServiceButton)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0), // Padding for left and right
                child: Container(
                  width: double.infinity, // Make it responsive
                  height: 54.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5.0,
                        offset: Offset(0, 0), // Even shadow on all sides
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                    onPressed: onTryService,
                    child: Text(
                      tryServiceText,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Inter',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
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
