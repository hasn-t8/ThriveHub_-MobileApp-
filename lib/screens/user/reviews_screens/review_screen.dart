import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thrive_hub/core/helper/time_helper.dart';
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
  bool isLoading = true; // Track loading state for reviews
  String errorMessage = ''; // For error handling

  @override
  void initState() {
    super.initState();
    _fetchReviews(); // Fetch reviews on initialization
  }

  // Fetch all reviews from the API
  Future<void> _fetchReviews() async {
    setState(() {
      isLoading = true; // Show loading only for the reviews area
    });

    try {
      final CompanyService reviewService = CompanyService();
      final List<dynamic> fetchedReviews = await reviewService.fetchAllReviews();
      final List<dynamic> fetchedReviewsbyuserid = await reviewService.fetchAllReviewsbyuserid();

      setState(() {
        allReviews = fetchedReviews.map((review) => Map<String, dynamic>.from(review)).toList();
        myReviews = fetchedReviewsbyuserid.map((review) => Map<String, dynamic>.from(review)).toList();
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

  @override
  Widget build(BuildContext context) {
    final reviews = isSavedSelected ? allReviews : myReviews;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reviews',
        showBackButton: false,
        centerTitle: true,
        showAddIcon: false,
        onAddPressed: () {},
      ),
      backgroundColor: Colors.white, // Set background color of the screen
      body: Padding(
        padding: const EdgeInsets.all(10.0), // Apply 10 padding to all sides
        child: Column(
          children: [
            // Tab Buttons (All / My Reviews)
            TabButtons(
              isAllSelected: isSavedSelected,
              onSelectAll: () {
                setState(() {
                  isSavedSelected = true;
                });
                _fetchReviews(); // Fetch latest reviews
              },
              onSelectMyReviews: () {
                setState(() {
                  isSavedSelected = false;
                });
                _fetchReviews(); // Fetch latest reviews
              },
              allText: 'All',
              myReviewsText: 'My reviews',
            ),
            SizedBox(height: 10.0),
            // Filter and Sort Buttons (Visible only for "All" tab)
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
                      sortOptions: ['Rating', 'Newest'],
                    ),
                  );
                },
                onFiltersUpdated: (updatedFilters) {
                  print("Filters updated: $updatedFilters");
                },
              ),
            SizedBox(height: 8.0),
            // Reviews List Area (with loader and error message)
            Expanded(
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
                  : reviews.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return ReviewCard(
                    imageUrl: review['logo_url'] ?? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtuphMb4mq-EcVWhMVT8FCkv5dqZGgvn_QiA&s',
                    title: review['org_name'] ?? 'No Title',
                    rating: (double.tryParse(review?['rating']?.toString() ?? '0.0') ?? 0.0) / 2,
                    location: review['location'] ?? '',
                    timeAgo : calculateTimeAgo(review['created_at']),
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
