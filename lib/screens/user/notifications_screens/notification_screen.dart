// import 'package:flutter/material.dart';
// import 'package:thrive_hub/widgets/appbar.dart';
// import 'package:thrive_hub/widgets/notification_card.dart'; // Import the NotificationCard widget
//
// class NotificationScreen extends StatefulWidget {
//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   @override
//
//   void initState() {
//     super.initState();
//   }
//
//   // Sample notification data
//   List<Map<String, dynamic>> notifications = [
//     {
//       'imageUrl': 'https://via.placeholder.com/150',
//       'title': 'Dropbox',
//       'time': '23 min ago',
//       'message': 'Dropbox responded to your comment',
//       'hasRedDot': true, // Show red dot
//     },
//     {
//       'imageUrl': 'https://via.placeholder.com/150',
//       'title': 'Google Drive',
//       'time': '1 hour ago',
//       'message': 'Google Drive shared a file with you',
//       'hasRedDot': false, // Do not show red dot
//     },
//     {
//       'imageUrl': 'https://via.placeholder.com/150',
//       'title': 'Thrive Hub',
//       'time': '3 hours ago',
//       'message': 'Thrive Hub is an ecommerce platform',
//       'hasRedDot': false, // Show red dot
//     },
//     // Add more notifications as needed
//   ];
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Notification',
//         showBackButton: true,
//         centerTitle: true,
//       ),
//       backgroundColor: Color(0xFFFFFFFF), // Set background color of the screen
//       body: notifications.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/main.png', // Replace with your image asset
//               width: 226,
//               height: 196,
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'You have no notifications yet',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontFamily: 'Inter', // Set the font family to 'Inter'
//                 fontWeight: FontWeight.w400, // Set font weight to 400
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       )
//           : ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           final notification = notifications[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 2.0), // Adjust padding here
//             child: NotificationCard(
//               imageUrl: notification['imageUrl'],
//               title: notification['title'],
//               time: notification['time'],
//               message: notification['message'],
//               hasRedDot: notification['hasRedDot'] ?? false, // Default to false if null
//               onViewTap: () {
//                 print('Notification card tapped!');
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }





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

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isSavedSelected = true; // Initially, All reviews are selected
  List<Map<String, dynamic>> allReviews = []; // List to hold all reviews
  List<Map<String, dynamic>> myReviews = []; // List for My Reviews
  List<Map<String, dynamic>> filteredReviews = []; // Filtered list of reviews
  List<String> selectedCategories = []; // Selected categories for filtering
  List<double> selectedRatings = []; // Selected ratings for filtering
  String? selectedSortOption; // Sorting option ("Newest" or "Rating")
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

      // Fetch all reviews and reviews by user ID independently
      List<dynamic> fetchedReviews = [];
      List<dynamic> fetchedReviewsByUserId = [];

      // Fetch all reviews
      try {
        fetchedReviews = await reviewService.fetchAllReviews();
      } catch (e) {
        print('Error fetching all reviews: $e');
        fetchedReviews = []; // Set to an empty list if an error occurs
      }

      // Fetch reviews by user ID
      try {
        fetchedReviewsByUserId = await reviewService.fetchAllReviewsbyuserid();
      } catch (e) {
        print('Error fetching reviews by user ID: $e');
        fetchedReviewsByUserId = []; // Set to an empty list if an error occurs
      }

      setState(() {
        allReviews = fetchedReviews
            .map((review) => Map<String, dynamic>.from(review))
            .toList();
        myReviews = fetchedReviewsByUserId
            .map((review) => Map<String, dynamic>.from(review))
            .toList();
        filteredReviews = List.from(allReviews); // Initialize filteredReviews
        _applyFiltersAndSorting(); // Apply filters and sorting initially
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

  // Apply filters and sorting to allReviews
  void _applyFiltersAndSorting({List<String> updatedFilters = const []}) {
    setState(() {
      // Check if "All" is in the filters
      if (updatedFilters.contains('All')) {
        filteredReviews = List.from(allReviews); // Show all reviews
        return; // Exit early, no further filtering needed
      }

      // Otherwise, apply category and rating filters
      filteredReviews = List.from(allReviews);

      // Separate ratings and categories dynamically from updatedFilters
      List<double> selectedRatings = updatedFilters
          .where((filter) => RegExp(r'^\d$')
          .hasMatch(filter)) // Numeric ratings like 5, 4, etc.
          .map((rating) => double.tryParse(rating)!)
          .toList();

      List<String> selectedCategories = updatedFilters
          .where((filter) =>
      !RegExp(r'^\d$').hasMatch(filter)) // Non-numeric categories
          .toList();

      // Apply category filter
      if (selectedCategories.isNotEmpty) {
        filteredReviews = filteredReviews.where((review) {
          return selectedCategories.contains(review['category']);
        }).toList();
      }

      // Apply rating filter
      if (selectedRatings.isNotEmpty) {
        filteredReviews = filteredReviews.where((review) {
          double reviewRating =
              (double.tryParse(review['rating']?.toString() ?? '0') ?? 0) / 2;
          return selectedRatings
              .contains(reviewRating); // Match any selected rating
        }).toList();
      }

      // Apply sorting
      if (selectedSortOption == 'Newest') {
        filteredReviews.sort((a, b) {
          DateTime dateA = DateTime.parse(a['created_at']);
          DateTime dateB = DateTime.parse(b['created_at']);
          return dateB.compareTo(dateA); // Descending order
        });
      } else if (selectedSortOption == 'Rating') {
        filteredReviews.sort((a, b) {
          double ratingA =
          (double.tryParse(a['rating']?.toString() ?? '0') ?? 0);
          double ratingB =
          (double.tryParse(b['rating']?.toString() ?? '0') ?? 0);
          return ratingB.compareTo(ratingA); // Descending order
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviews = isSavedSelected ? filteredReviews : myReviews;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        showBackButton: true,
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
            // TabButtons(
            //   isAllSelected: isSavedSelected,
            //   onSelectAll: () {
            //     setState(() {
            //       isSavedSelected = true;
            //     });
            //   },
            //   onSelectMyReviews: () {
            //     setState(() {
            //       isSavedSelected = false;
            //     });
            //   },
            //   allText: 'All',
            //   myReviewsText: 'My reviews',
            // ),
            // SizedBox(height: 10.0),
            // Filter and Sort Buttons (Visible only for "All" tab)
            if (isSavedSelected)
              FilterSortButtons(
                onFilter: (context) async {
                  // Navigate to the filter screen and await the selected filters
                  final List<String>? filters =
                  await Navigator.push<List<String>>(
                    context,
                    MaterialPageRoute(builder: (context) => FilterScreen()),
                  );

                  // Return the latest filters or an empty list if null
                  return filters ?? [];
                },
                onSort: (context) async {
                  final String? sortOption = await showModalBottomSheet<String>(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) => const SortBottomSheet(
                      title: 'Sort By',
                      sortOptions: ['Rating', 'Newest'],
                    ),
                  );

                  if (sortOption != null) {
                    setState(() {
                      selectedSortOption = sortOption;
                    });
                    _applyFiltersAndSorting(updatedFilters: []);
                  }
                },
                onFiltersUpdated: (updatedFilters) {
                  // Use the latest filters directly in the filtering logic
                  _applyFiltersAndSorting(updatedFilters: updatedFilters);
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
                      'No reviews match your filter criteria.',
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
                    imageUrl: review['logo_url'] ??
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtuphMb4mq-EcVWhMVT8FCkv5dqZGgvn_QiA&s',
                    title: review['org_name'] ?? 'No Title',
                    rating: (double.tryParse(
                        review?['rating']?.toString() ??
                            '0.0') ??
                        0.0) /
                        2,
                    location: review['location'] ?? '',
                    timeAgo:
                    calculateTimeAgo(review['created_at']),
                    reviewerName:
                    review['customer_name'] ?? 'Anonymous',
                    reviewText: review['feedback'] ??
                        'No review text provided.',
                    likes: review['likes'] ?? 0,
                    isLiked: review['isLiked'] ?? false,
                    onTap: () {
                      print(
                          'ReviewCard tapped: ${review['title']}');
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
