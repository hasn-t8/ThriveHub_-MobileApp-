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
    return InkWell(
      onTap: widget.onTap, // Trigger onTap when the card is clicked
      child: Card(
        margin: EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ), // Rounded corner only at the top left
        ),
        child: Container(
          width: 344.0, // Fixed width
          height: 238.0, // Fixed height
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 2.0,
                spreadRadius: 2, // Adjust the blur for softness
                offset: Offset(0, 2), // Adjust the offset
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0), // Padding
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
                      borderRadius: BorderRadius.circular(16.0),
                      color: Color(0xFFD9D9D9),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Show "..." if the text overflows
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            Text(
                              widget.rating.toString(),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(
                              Icons.star,
                              size: 14.0,
                              color: Color(0xFF888686), // Star color
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '|',
                              style: TextStyle(fontSize: 14.0, color: Color(0xFFA5A5A5)),
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              '${widget.reviews} Reviews',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF888686),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.0),
                        if (widget.service.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFA5A5A5)),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              widget.service,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xFF4D4D4D),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
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
                  fontFamily: 'Inter',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  height: 17.5 / 14.0,
                  color: Color(0xFFA5A5A5),
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.left,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.0),
              GestureDetector(
                onTap: () {
                  // Handle the "Learn more" tap
                },
                child: Text(
                  'Learn more',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFFA5A5A5),
                    decoration: TextDecoration.underline,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    decorationColor: Color(0xFFA5A5A5),
                    decorationThickness: 1.5,
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
