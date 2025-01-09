import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thrive_hub/screens/user/reviews_screens/create_review_screen.dart';
import 'package:thrive_hub/screens/user/reviews_screens/review_screen.dart';
import 'package:thrive_hub/screens/search_screens/filter_screen.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/sort.dart';
import 'package:thrive_hub/widgets/tab_buttons.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool isSavedSelected = true; // Initially, All reviews are selected
  List<Map<String, dynamic>> allReviews = []; // List to hold all reviews
  List<Map<String, dynamic>> myReviews = []; // List for My Reviews
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // For error handling

  @override
  void initState() {
    super.initState();
    _fetchReviews(); // Fetch reviews on initialization
  }

  // Fetch all reviews from the API
  Future<void> _fetchReviews() async {
    try {
      final CompanyService reviewService = CompanyService();
      final List<dynamic> fetchedReviews = await reviewService.fetchAllReviews();

      setState(() {
        allReviews = fetchedReviews.map((review) => Map<String, dynamic>.from(review)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
        print('Error fetching reviews: $errorMessage');
      });
    }
  }
  String _calculateDaysAgo(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return 'Some time ago';
    }
    DateTime parsedDate = DateTime.parse(createdAt);
    DateTime now = DateTime.now();
    int daysDifference = now.difference(parsedDate).inDays;
    return '$daysDifference day${daysDifference != 1 ? 's' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final reviews = isSavedSelected ? allReviews : myReviews;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reviews',
        showBackButton: false,
        centerTitle: true,
        onAddPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateReviewScreen()),
          );
        },
      ),
      backgroundColor: Colors.white, // Set background color of the screen
      body: isLoading
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
          : Padding(
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
              allText: 'All',
              myReviewsText: 'My reviews',
            ),
            SizedBox(height: 10.0),
            if (isSavedSelected)
              FilterSortButtons(
                onFilter: (context) async {
                  return await Navigator.push<List<String>>(
                    context,
                    MaterialPageRoute(builder: (context) => FilterScreen()),
                  ) ??
                      [];
                },
                onSort: (context) async {
                  return await showModalBottomSheet<String>(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) => const SortBottomSheet(
                      title: 'Sort By',
                      sortOptions: ['Price Low to High', 'Price High to Low', 'Rating', 'Newest'],
                    ),
                  );
                },
                onFiltersUpdated: (updatedFilters) {
                  print("Filters updated: $updatedFilters");
                },
              ),
            SizedBox(height: 8.0),
            Expanded(
              child: reviews.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/no_review.png',
                      width: 254,
                      height: 256,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      isSavedSelected
                          ? 'No reviews found'
                          : 'You have not written any review yet',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro Display',
                        height: 1.43,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      width: 343,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CreateReviewScreen()),
                          );
                        },
                        child: Text(
                          'Write a Review',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 19, vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
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
                    imageUrl: review['logo_url'] ?? 'https://via.placeholder.com/40',
                    title: review['org_name'] ?? 'No Title',
                    rating: (double.tryParse(review?['rating']?.toString() ?? '0.0') ?? 0.0) / 2,
                    location: review['location'] ?? '',
                    timeAgo: _calculateDaysAgo(review['created_at']),
                    reviewerName: review['customer_name'] ?? 'Anonymous',
                    reviewText: review['feedback'] ?? 'No review text provided.',
                    likes: review['likes'] ?? 0,
                    isLiked: review['isLiked'] ?? false,
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
