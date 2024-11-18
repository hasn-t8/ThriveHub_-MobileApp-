import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thrive_hub/screens/user/reviews_screens/create_review_screen.dart';
import 'package:thrive_hub/screens/user/reviews_screens/review_screen.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/tab_buttons.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart'; // Import the new FilterSortButtons widget

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
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
      'reviewText':
      'This is a review for company $index. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
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
        onAddPressed: () {
          // Handle the + icon press action here
          print('Add icon pressed!');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateReviewScreen()),
          );
        },
      ),
      backgroundColor: Colors.white, // Set background color of the screen
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Apply 10 padding to all sides
        child: Column(
          children: [
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
            if (isSavedSelected) // Conditionally show FilterSortButtons
            FilterSortButtons(
              onFilter: () {
                // Handle filter action
              },
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
                      style:TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 14, // Equivalent to the 12px font-size
                        fontWeight: FontWeight.w500, // Regular weight
                        fontFamily: 'SF Pro Display', // Set the font to 'SF Pro Display'
                        height: 1.43,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      width: 343, // Fixed width in pixels
                      height: 54, // Fixed height in pixels
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
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter', // Set the font family
                            fontSize: 16, // Font size
                            fontWeight: FontWeight.w500, // Medium weight
                            height: 1.25, // Line height (20px / 16px)
                            textBaseline: TextBaseline.alphabetic, // Ensures proper alignment
                          ),
                          textAlign: TextAlign.left, // Align text to the left
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white, // White background
                          padding: EdgeInsets.symmetric(horizontal: 19, vertical: 17), // Custom padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16),),
                            side: BorderSide(color: Color(0xFFA5A5A5)), // Border color
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
      ),
    );
  }
}
