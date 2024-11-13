import 'package:flutter/material.dart';

class ServiceSummaryCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> boxTexts; // Dynamic box text list

  const ServiceSummaryCard({
    Key? key,
    required this.title,
    required this.description,
    required this.boxTexts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Removed the shadow from the main container
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.25, // Line height: 25px / font size: 20px
            ),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.28, // Line height: 18px / font size: 14px
              letterSpacing: -0.08,
            ),
          ),
          const SizedBox(height: 16),
          // Dynamic Boxes
          Wrap(
            spacing: 4, // Gap between boxes
            runSpacing: 6,
            children: boxTexts.map((text) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 6, // Adjust padding for dynamic width
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.38,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                  textAlign: TextAlign.left,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
