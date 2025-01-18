import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thrive_hub/core/helper/time_helper.dart';
import 'package:thrive_hub/core/utils/no_page_found.dart';
import 'package:thrive_hub/screens/search_screens/filter_screen.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/feedback_bottom_sheet.dart';
import 'package:thrive_hub/widgets/rating_card.dart';
import 'package:thrive_hub/widgets/service_card.dart';
import 'package:thrive_hub/widgets/service_summary_card.dart';
import 'package:thrive_hub/widgets/service_tabs.dart';
import 'package:thrive_hub/widgets/service_about_tab.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/sort.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ServicesScreen extends StatefulWidget {
  final String business_profile_id;

  const ServicesScreen({Key? key, required this.business_profile_id})
      : super(key: key);
  // ServicesScreen({required this.profileId});

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool isFirstTabSelected = true; // State to track the selected tab
  Map<String, dynamic>? businessProfile;
  List<Map<String, dynamic>> allReviews = []; // Updated to fetch from API
  List<Map<String, dynamic>> filteredReviews = []; // Filtered list of reviews
  List<String> selectedCategories = []; // Selected categories for filtering
  List<double> selectedRatings = []; // Selected ratings for filtering
  String? selectedSortOption; // Sorting option ("Newest" or "Rating")
  bool isLoading = true;
  String errorMessage = '';
  // Initialize rating distribution
  Map<int, double> ratingDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  List<String>? userTypes;

  @override
  void initState() {
    super.initState();
    _fetchBusinessProfile();
    _fetchReviews(); // Fetch reviews when the screen initializes
    _loadUserTypes();
  }
  void showFeedbackBottomSheet(BuildContext context, String companyTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => FeedbackBottomSheet(companyTitle: businessProfile?['org_name'] ?? '',business_profile_id: widget.business_profile_id),
    );
  }

  Future<void> _loadUserTypes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userTypes = prefs.getStringList('user_types') ?? [];
    });
  }

  Future<void> _fetchBusinessProfile() async {
    try {
      CompanyService companyService = CompanyService();
      final profile = await companyService
          .getBusinessProfileById(widget.business_profile_id);
      setState(() {
        businessProfile = profile;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _fetchReviews() async {
    if (businessProfile == null) {
      await _fetchBusinessProfile(); // Ensure business profile is fetched first
    }
    try {
      CompanyService companyService = CompanyService();
      final reviews = await companyService
          .getReviewsByBusinessId(widget.business_profile_id);

      // Map to count the ratings for distribution
      Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

      setState(() {
        allReviews = reviews.map<Map<String, dynamic>>((review) {
          double originalRating =
              double.tryParse(review?['rating']?.toString() ?? '0.0') ?? 0.0;
          int scaledRating =
              (originalRating / 2).ceil().clamp(1, 5); // Scale to 1-5

          // Update the count for the rating distribution
          ratingCounts[scaledRating] = (ratingCounts[scaledRating] ?? 0) + 1;

          return {
            'imageUrl': businessProfile?['logo_url'] ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtuphMb4mq-EcVWhMVT8FCkv5dqZGgvn_QiA&s',
            'title': businessProfile?['org_name'] ?? '',
            'rating': scaledRating.toDouble(),
            'location': review['location'] ?? '',
            'timeAgo':calculateTimeAgo(review['created_at']),
            'reviewerName': review['customer_name'] ?? 'Anonymous',
            'reviewText': review['feedback'] ?? 'No review text provided.',
            'likes': review['likes'] ?? 0,
            'isLiked': review['isLiked'] ?? false,
          };
        }).toList();

        filteredReviews = List.from(allReviews); // Initially show all reviews
        _applyFiltersAndSorting(); // Apply filters and sorting initially
        // Calculate the rating distribution percentages
        int totalReviews = allReviews.length;
        ratingDistribution = {
          5: totalReviews > 0 ? (ratingCounts[5]! / totalReviews) * 100 : 0,
          4: totalReviews > 0 ? (ratingCounts[4]! / totalReviews) * 100 : 0,
          3: totalReviews > 0 ? (ratingCounts[3]! / totalReviews) * 100 : 0,
          2: totalReviews > 0 ? (ratingCounts[2]! / totalReviews) * 100 : 0,
          1: totalReviews > 0 ? (ratingCounts[1]! / totalReviews) * 100 : 0,
        };
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
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
              (double.tryParse(review['rating']?.toString() ?? '0') ?? 0) ;
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
              NoPageFound.show(context);
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: 9000,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Card
                ServiceCard(
                  userTypes: userTypes!,
                  serviceName: businessProfile?['org_name'] ?? '',
                  imageUrl: businessProfile?['logo_url'] ??
                      'https://cdn.pixabay.com/photo/2019/03/13/14/08/building-4052951_640.png',
                  rating: (double.tryParse(
                              businessProfile?['avg_rating']?.toString() ??
                                  '0.0') ??
                          0.0) /
                      2,
                  reviewCount: businessProfile?['total_reviews'] ?? 0,
                  location: businessProfile?['location'] ?? '',
                  onWriteReview: () {
                    print("create a service clicked");
                    showFeedbackBottomSheet(context, "Thrive hub");
                  },
                  // showWriteReviewButton: true,
                  showTryServiceButton: false,
                  onTryService: () {
                    print("Try Service clicked");
                  },
                  writeReviewText: 'Write a Review',
                ),

                // Centered Service Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ServiceTabs(
                      firstTabText: 'Reviews (${filteredReviews.length})',
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
                            rating: (double.tryParse(
                                        businessProfile?['avg_rating']
                                                ?.toString() ??
                                            '0.0') ??
                                    0.0) /
                                2,
                            totalReviews:
                                businessProfile?['total_reviews'] ?? 0,
                            ratingDistribution:
                                ratingDistribution, // Use dynamic distribution
                          ),

                          const SizedBox(height: 16),
                          if (allReviews.isNotEmpty)
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
                          // Review List
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filteredReviews.length,
                            itemBuilder: (context, index) {
                              final review = filteredReviews[index];
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
                        ],
                      )
                    : ServiceAboutTab(
                        heading: "Business Details",
                        description: businessProfile?['about_business'] ??
                            'No business detail found...',
                        title: "website",
                        companyName: businessProfile?['org_name'] ?? '/',
                        companyUrl: businessProfile?['business_website_url'] ??
                            'https://thrivehub.ai/',
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
