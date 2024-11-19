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
    this.showWriteReviewButton = true,
    this.showTryServiceButton = true,
    this.writeReviewText = 'Write a Review',
    this.tryServiceText = 'Try Service',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 270.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.transparent,
      ),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and Info Section
            Container(
              width: double.infinity,
              height: 128.0,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  // Image Container
                  Container(
                    width: 90.0,
                    height: 96.0,
                    decoration: const BoxDecoration(
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
                  const SizedBox(width: 13.0),
                  // Info Section
                  Expanded(
                    child: SizedBox(
                      height: 96.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceName,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.35,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              Text('$rating', style: const TextStyle(color: Color(0xFF888686))),
                              const Icon(Icons.star, color: Color(0xFF888686)),
                              const SizedBox(width: 8.0),
                              const Text('|', style: TextStyle(color: Color(0xFFA5A5A5))),
                              const SizedBox(width: 8.0),
                              Text('$reviewCount Reviews', style: const TextStyle(color: Color(0xFF888686))),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Color(0xFF4D4D4D)),
                              Text(
                                location,
                                style: const TextStyle(
                                  color: Color(0xFFA5A5A5),
                                  fontFamily: 'Inter',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFFA5A5A5),
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
            const SizedBox(height: 16.0),
            // Buttons Section
            if (showWriteReviewButton || showTryServiceButton)
              Column(
                children: [
                  if (showWriteReviewButton)
                    Container(
                      width: double.infinity,
                      height: 54.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: onWriteReview,
                        child: Text(
                          writeReviewText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  if (showTryServiceButton)
                    Container(
                      width: double.infinity,
                      height: 54.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          shadowColor: Colors.black.withOpacity(0.5),
                          // elevation: 5,
                        ),
                        onPressed: onTryService,
                        child: Text(
                          tryServiceText,
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
