import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thrive_hub/widgets/feedback_bottom_sheet.dart';
import 'package:thrive_hub/widgets/rating_card.dart';
import 'package:thrive_hub/widgets/service_card.dart';
import 'package:thrive_hub/widgets/service_summary_card.dart';
import 'package:thrive_hub/widgets/service_tabs.dart';
import 'package:thrive_hub/widgets/service_about_tab.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';
import 'package:thrive_hub/widgets/review_card.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool isFirstTabSelected = true; // State to track the selected tab

  // Sample data for reviews
  final List<Map<String, dynamic>> allReviews = List.generate(
    5,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // Bookmark logic
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Card
              ServiceCard(
                serviceName: 'Bluehost',
                imageUrl: 'https://via.placeholder.com/90x96',
                rating: 4.8,
                reviewCount: 4876,
                location: 'Location Text',
                onWriteReview: () {
                  print("Write a Review clicked");
                  showFeedbackBottomSheet(context, "Thrive hub");
                },

                onTryService: () {
                  print("Try Service clicked");
                },
                showWriteReviewButton: true,
                showTryServiceButton: true,
                writeReviewText: 'Write Your Review',
                tryServiceText: 'Try the service with discount',
              ),

              const SizedBox(height: 16),


              // Centered Service Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ServiceTabs(
                    firstTabText: 'Reviews (23)',
                    secondTabText: 'About',
                    onTabSelected: (isFirstTab) {
                      setState(() {
                        isFirstTabSelected = isFirstTab;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tab Content
              isFirstTabSelected
                  ? Column(
                children: [
                  // Rating Card
                  RatingCard(
                    rating: 3.5,
                    totalReviews: 4876,
                    ratingDistribution: {
                      5: 70.0,
                      4: 30.0,
                      3: 20.0,
                      2: 10.0,
                      1: 3.0,
                    },
                  ),

                  const SizedBox(height: 16),

                  // Filter and Sort Buttons
                  FilterSortButtons(
                    onFilter: () {
                      print('Filter action triggered');
                    },
                  ),

                  const SizedBox(height: 16),

                  // Service Summary Card
                  ServiceSummaryCard(
                    title: 'Service Summary',
                    description:
                    'Here is a detailed summary of the service offered.',
                    boxTexts: [
                      'Customer Service',
                      'Technological',
                      'Quality',
                      'Team',
                      'Digital',
                      'Sustainability',
                      'Innovation',
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Review List
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allReviews.length,
                    itemBuilder: (context, index) {
                      final review = allReviews[index];
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
                ],
              )
                  : ServiceAboutTab(
                heading: "About Service",
                description:
                "Bluehost is the best web hosting provider that offers reliable and affordable website hosting plans with easy-to-use tools. With 24/7 customer support, domain name registration, and dedicated WordPress and WooCommerce hosting, Bluehost is a great choice for individuals and businesses looking to run a successful website.",
                title: "Contacts",
                location: "123 Main Street, City, Country",
                phoneNumber: "+123456789",
                companyName: "Tech Solutions Inc.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
