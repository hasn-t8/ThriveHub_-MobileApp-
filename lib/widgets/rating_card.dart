import 'package:flutter/material.dart';

class RatingCard extends StatelessWidget {
  final double rating; // Overall rating (e.g., 4.5)
  final int totalReviews; // Total number of reviews
  final Map<int, double> ratingDistribution; // Rating distribution (e.g., {5: 70.0, 4: 20.0})

  const RatingCard({
    Key? key,
    required this.rating,
    required this.totalReviews,
    required this.ratingDistribution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(16), // Rounded corners for the whole container
      ),
      child: Row(
        children: [
          // Left Side (Rating, Stars, and Reviews)
          SizedBox(
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Dynamic Rating Number
                Text(
                  '${rating.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                // Dynamic Stars Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    if (index < rating.floor()) {
                      // Full Star
                      return const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.black,
                      );
                    } else if (index == rating.floor() && (rating - rating.floor()) >= 0.5) {
                      // Half Star
                      return const Icon(
                        Icons.star_half,
                        size: 16,
                        color: Colors.black,
                      );
                    } else {
                      // Empty Star
                      return const Icon(
                        Icons.star_border,
                        size: 16,
                        color: Colors.black,
                      );
                    }
                  }),
                ),

                const SizedBox(height: 8),
                // Dynamic Total Reviews
                Text(
                  '$totalReviews Reviews',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
              ],
            ),
          ),

          // Right Side (Rating Distribution)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(ratingDistribution.length, (index) {
                final ratingNumber = 5 - index; // Reverse order (5 to 1)
                final percentage = ratingDistribution[ratingNumber] ?? 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // Spacing between rows
                  child: Row(
                    children: [
                      // Dynamic Rating Number and Star
                      Row(
                        children: [
                          const SizedBox(width: 5),
                          Icon(
                            Icons.star,
                            size: 12,
                            color: Colors.black,
                          ),
                          Text(
                            ratingNumber.toString(),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(width: 10),
                      // Dynamic Rating Bar
                      Expanded(
                        child: Container(
                          height: 8, // Bar height
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8), // Rounded corners for bar
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: percentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF4D4D4D),
                                borderRadius: BorderRadius.circular(8), // Rounded corners for fillable bar
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Dynamic Percentage Text
                      Text(
                        "${percentage.toInt()}%",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4D4D4D),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
