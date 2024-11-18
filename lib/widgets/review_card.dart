import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final String location;
  final String timeAgo;
  final String reviewerName;
  final String reviewText;
  final int likes;
  final bool isLiked; // New parameter to indicate like status
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback? onTap; // Add this for overall card tap
  final bool showShareButton;
  final bool showDivider;

  ReviewCard({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.location,
    required this.timeAgo,
    required this.reviewerName,
    required this.reviewText,
    required this.likes,
    required this.isLiked, // Initialize the new parameter
    required this.onLike,
    required this.onShare,
    this.onTap, // Initialize as optional
    this.showShareButton = true,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle the onTap callback
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        shadowColor: Colors.grey.withOpacity(0.5),
        elevation: 4,
        color: Color(0xFFF1F3F4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFD9D9D9),
                    radius: 20.0,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SF Pro Display',
                            height: 1.19357,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              rating.toString(),
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'SF Pro Display',
                                height: 18.2 / 13,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Icon(Icons.star, color: Color(0xFF4D4D4D), size: 18.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Color(0xFF4D4D4D), size: 16.0),
                          SizedBox(width: 4.0),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Color(0xFF777777),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SF Pro Display',
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFF79747E),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SF Pro Display',
                          height: 18.2 / 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              if (showDivider)
                Divider(
                  thickness: 1.2,
                  color: Color(0xFFE9E8E8),
                )
              else
                SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  // Handle reviewer name tap
                },
                child: Text(
                  reviewerName,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    height: 14.5 / 12,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                reviewText,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF777777),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF Pro Display',
                  height: 21 / 14,
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onLike,
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border, // Conditional Icon
                          color: const Color(0xFF434242),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          likes.toString(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            height: 18.0 / 14.0,
                            letterSpacing: -0.08,
                            color: Color(0xFF434242),
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.0),
                  if (showShareButton)
                    GestureDetector(
                      onTap: onShare,
                      child: Icon(
                        Icons.share_outlined,
                        color: Color(0xFF434242),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
