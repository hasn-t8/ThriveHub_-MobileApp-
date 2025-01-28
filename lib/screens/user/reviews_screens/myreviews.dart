import 'package:flutter/material.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/core/helper/time_helper.dart';

class MyReviewsScreen extends StatefulWidget {
  @override
  _MyReviewsScreenState createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  List<Map<String, dynamic>> myReviews = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchMyReviews();
  }

  // Fetch reviews specific to the user
  Future<void> _fetchMyReviews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final CompanyService reviewService = CompanyService();
      List<dynamic> fetchedReviewsByUserId = [];

      try {
        fetchedReviewsByUserId = await reviewService.fetchAllReviewsbyuserid();
      } catch (e) {
        print('Error fetching reviews by user ID: $e');
        fetchedReviewsByUserId = [];
      }

      setState(() {
        myReviews = fetchedReviewsByUserId
            .map((review) => Map<String, dynamic>.from(review))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'An unexpected error occurred. Please try again later.';
        print('Unexpected error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Reviews',
        showBackButton: true,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : errorMessage.isNotEmpty
            ? Center(
          child: Text(
            'Error: $errorMessage',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        )
            : myReviews.isEmpty
            ? Center(
          child: Text(
            'No reviews found.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            : ListView.builder(
          itemCount: myReviews.length,
          itemBuilder: (context, index) {
            final review = myReviews[index];
            return ReviewCard(
              imageUrl: review['logo_url'] ??
                  'https://via.placeholder.com/150',
              title: review['org_name'] ?? 'No Title',
              rating: (double.tryParse(
                  review['rating']?.toString() ?? '0.0') ??
                  0.0) /
                  2,
              location: review['location'] ?? '',
              timeAgo: calculateTimeAgo(review['created_at']),
              reviewerName:
              review['customer_name'] ?? 'Anonymous',
              reviewText: review['feedback'] ??
                  'No review text provided.',
              likes: review['likes'] ?? 0,
              isLiked: review['isLiked'] ?? false,
              onTap: () {
                print('ReviewCard tapped: ${review['title']}');
              },
            );
          },
        ),
      ),
    );
  }
}
