import 'package:flutter/material.dart';

class CompanyCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final int reviews;
  final String service;
  final String description;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback? onTap; // Add onTap callback

  const CompanyCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.reviews,
    this.service = ' ', // Make `service` optional with a default empty string
    required this.description,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    this.onTap, // Optional onTap for card click
  }) : super(key: key);

  @override
  _CompanyCardState createState() => _CompanyCardState();
}

class _CompanyCardState extends State<CompanyCard> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    widget.onBookmarkToggle();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell( // Wrap the entire card with InkWell
      onTap: widget.onTap, // Trigger onTap when the card is clicked
      child: Card(
        margin: EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.grey, width: 1.0),
        ),
        color: Colors.white, // Set card background color to white
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 93,
                    height: 93,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners for image
                      color: Color(0xFFD9D9D9),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0), // Ensures image is clipped with rounded corners
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Text(
                              widget.rating.toString(),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            Icon(
                              Icons.star,
                              size: 14.0,
                              color: Color(0xFF888686), // Star color
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '|',
                              style: TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '${widget.reviews} Reviews',
                              style: TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        if (widget.service.isNotEmpty) // Check if the service is not empty
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              widget.service,
                              style: TextStyle(fontSize: 12.0, color: Colors.black),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: _isBookmarked ? Color(0xFFA5A5A5) : Colors.black,
                    ),
                    onPressed: _toggleBookmark,
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.0), // Add some space between the description and the "Learn more" text
              GestureDetector(
                onTap: () {
                  // Handle the "Learn more" tap
                },
                child: Text(
                  'Learn more',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
