import 'package:flutter/material.dart';

class ServiceAboutTab extends StatefulWidget {
  final String heading;
  final String description;
  final String title;
  final String location;
  final String phoneNumber;
  final String companyName;

  const ServiceAboutTab({
    Key? key,
    required this.heading,
    required this.description,
    required this.title,
    required this.location,
    required this.phoneNumber,
    required this.companyName,
  }) : super(key: key);

  @override
  _ServiceAboutTabState createState() => _ServiceAboutTabState();
}

class _ServiceAboutTabState extends State<ServiceAboutTab> {
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Text(
            widget.heading,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.38,
              height: 1.25,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            widget.description,
            maxLines: showFullDescription ? null : 3,
            overflow: showFullDescription ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF79747E),
              height: 1.25,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),

          // Show More / Show Less
          GestureDetector(
            onTap: () {
              setState(() {
                showFullDescription = !showFullDescription;
              });
            },
            child: Text(
              showFullDescription ? "Show Less" : "Show More",
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFFA5A5A5), // Text color
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFFA5A5A5), // Underline color
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),

          ),
          const SizedBox(height: 16),

          // Title
          Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.35,
              height: 1.27,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 16),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on, size: 20, color: Color(0xFF4D4D4D)),
              const SizedBox(width: 8),
              Text(
                widget.location,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA5A5A5), // Text color
                  decoration: TextDecoration.underline, // Underline
                  decorationColor: Color(0xFFA5A5A5), // Underline color
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Phone
          Row(
            children: [
              const Icon(Icons.phone, size: 20, color: Color(0xFF4D4D4D)),
              const SizedBox(width: 8),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA5A5A5), // Text color
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Company
          Row(
            children: [
              const Icon(Icons.business_center_outlined, size: 20, color: Color(0xFF4D4D4D)),
              const SizedBox(width: 8),
              Text(
                widget.companyName,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFA5A5A5), // Text color
                  decoration: TextDecoration.underline, // Underline
                  decorationColor: Color(0xFFA5A5A5), // Underline color
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
