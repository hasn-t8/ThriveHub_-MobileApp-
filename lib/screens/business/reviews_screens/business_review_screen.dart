import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thrive_hub/core/utils/thank_you.dart';
import 'package:thrive_hub/screens/business/widgets/description_bottom_sheet.dart';
import 'package:thrive_hub/screens/user/reviews_screens/create_review_screen.dart';
import 'package:thrive_hub/screens/user/search_screens/filter_screen.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/sort.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';

class BusinessReviewScreen extends StatefulWidget {
  @override
  _BusinessReviewScreenState createState() => _BusinessReviewScreenState();
}

class _BusinessReviewScreenState extends State<BusinessReviewScreen> {

  final TextEditingController _descriptionController = TextEditingController();

  String? _description;
  File? _selectedImage;


  void _saveDescription(String description, File? selectedImage) {
    setState(() {
      _description = description;
      _selectedImage = selectedImage;
    });
    ThankYou.show(context);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ReusableBottomSheet(
          descriptionController: _descriptionController,
          onSave: _saveDescription,
          initialSelectedImage: _selectedImage,
          onClose: () => Navigator.pop(context),
        );
      },
    );
  }
  // Sample data for reviews with a mix of replied and unreplied reviews
  final List<Map<String, dynamic>> reviews = [
    {
      "id": 1,
      "imageUrl": "https://via.placeholder.com/40",
      "title": "Company ABC",
      "rating": 4.5,
      "location": "New York, USA",
      "timeAgo": "2 days ago",
      "reviewerName": "John Doe",
      "reviewText": "Great service and friendly staff!",
      "likes": 23,
      "isLiked": false,
      "reply": {
        "replyTitle": "Business Response",
        "replyTimeAgo": "1 day ago",
        "replyMessage": "Thank you for your kind words! We’re glad you had a great experience."
      }
    },
    {
      "id": 2,
      "imageUrl": "https://via.placeholder.com/40",
      "title": "Company XYZ",
      "rating": 3.8,
      "location": "San Francisco, USA",
      "timeAgo": "5 days ago",
      "reviewerName": "Jane Smith",
      "reviewText": "Good service, but can improve on delivery time.",
      "likes": 12,
      "isLiked": false,
      "reply": null // No reply exists
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reviews',
        showBackButton: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.white, // Set background color of the screen to white
      body: reviews.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/no_review.png', // Replace with your actual image path
              width: 254,
              height: 256,
            ),
          ],
        ),
      )
          : Column(
        children: [
          SizedBox(height: 10.0), // Space between app bar and filter/sort buttons
          FilterSortButtons(
            onFilter: (context) async {
              // Your filter logic here
              return await Navigator.push<List<String>>(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              ) ??
                  [];
            },
            onSort: (context) async {
              // Your sort logic here
              return await showModalBottomSheet<String>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const SortBottomSheet(
                  title: 'Sort', // Pass custom title
                  sortOptions: ['By Service', 'No answer', 'with answer', 'Newest'], // Pass custom options
                ),
              );
            },
          ),
          SizedBox(height: 8.0), // Space between filter/sort buttons and review cards
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                final hasReply = review['reply'] != null;

                return ReviewCard(
                  imageUrl: review['imageUrl'],
                  title: review['title'],
                  rating: review['rating'],
                  location: review['location'],
                  timeAgo: review['timeAgo'],
                  reviewerName: review['reviewerName'],
                  reviewText: review['reviewText'],
                  likes: review['likes'],
                  isLiked: review['isLiked'],
                  showReplyButton: !hasReply, // Show reply button only if no reply exists
                  onReply: () {
                    // Navigate to reply creation screen or handle reply action
                    _showBottomSheet(context);
                  },
                  isReplied: hasReply, // Mark as replied if a reply exists
                  replyTitle: hasReply ? review['reply']['replyTitle'] : null,
                  replyTimeAgo: hasReply ? review['reply']['replyTimeAgo'] : null,
                  replyMessage: hasReply ? review['reply']['replyMessage'] : null,
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
