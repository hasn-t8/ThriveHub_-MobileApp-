import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thrive_hub/screens/user/reviews_screens/create_review_screen.dart';
import 'package:thrive_hub/screens/business/reviews_screens/business_review_screen.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/tab_buttons.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart'; // Import the new FilterSortButtons widget

class BusinessReviewScreen extends StatefulWidget {
  @override
  _BusinessReviewScreenState createState() => _BusinessReviewScreenState();
}

class _BusinessReviewScreenState extends State<BusinessReviewScreen> {
  bool isSavedSelected = true; // Initially, Saved button is selected

  // Sample data for reviews
  final List<Map<String, dynamic>> allReviews = List.generate(
    10,
        (index) => {
      'imageUrl': 'https://via.placeholder.com/40',
      'title': 'Company $index',
      'rating': 4.8,
      'location': 'USA',
      'timeAgo': '1 day ago',
      'reviewerName': 'Reviewer $index',
      'reviewText': 'This is a review for company $index. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'likes': 43,
      'isLiked': false,

    },
  );

  final List<Map<String, dynamic>> myReviews = []; // Empty list for my reviews

  @override
  Widget build(BuildContext context) {
    final reviews = isSavedSelected ? allReviews : myReviews;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reviews',
        showBackButton: false,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF1F3F4), // Set background color of the screen
      body: Column(
        children: [
          SizedBox(height: 10.0), // Space between AppBar and buttons
          TabButtons(
            isAllSelected: isSavedSelected,
            onSelectAll: () {
              setState(() {
                isSavedSelected = true;
              });
            },
            onSelectMyReviews: () {
              setState(() {
                isSavedSelected = false;
              });
            },
            allText: 'All', // Customizable text for the "All" button
            myReviewsText: 'My reviews', // Customizable text for the "My reviews" button
          ),
          SizedBox(height: 10.0), // Space between buttons and filter/sort buttons
          FilterSortButtons(
            onFilter: () {
              // Handle filter action
            },
            // onSort: () {
            //   // Handle sort action
            // },
          ),
          SizedBox(height: 8.0), // Space between filter/sort buttons and review cards
          Expanded(
            child: reviews.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/no_review.png', // Replace with your actual image path
                    width: 254,
                    height: 256,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'You have not written any review yet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 32,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle button action
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateReviewScreen()),
                        );
                      },
                      child: Text(
                        'Write a Review',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(color: Color(0xFFA5A5A5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewCard(
                  imageUrl: review['imageUrl'],
                  title: review['title'],
                  rating: review['rating'],
                  location: review['location'],
                  timeAgo: review['timeAgo'],
                  reviewerName: review['reviewerName'],
                  reviewText: review['reviewText'],
                  likes: review['likes'],
                  isLiked:review['isLiked'],
                  onTap: () {
                    print('ReviewCard tapped: ${review['title']}');
                  },
                  onLike: () {
                    setState(() {
                      if (review['isLiked']) {
                        review['likes'] -= 1;
                      } else {
                        review['likes'] += 1;
                      }
                      review['isLiked'] = !review['isLiked'];
                    });
                  },
                  onShare: () {
                    Share.share(
                      'Check out this review on Thrive Hub:\n\n"${review['reviewText']}"\nRead more at: https://example.com/review/${review['title']}',
                      subject: 'Review of ${review['title']}',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
