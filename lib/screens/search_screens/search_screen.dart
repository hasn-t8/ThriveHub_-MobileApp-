import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/screens/search_screens/sub_categories.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/categories.dart';
import 'package:thrive_hub/widgets/top_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = ''; // Replace with the actual name variable or dynamic input
  int selectedBoxIndex = -1;
  List<Map<String, dynamic>> allReviews = [];
  List<Map<String, dynamic>> filteredReviews = [];
  bool isLoadingReviews = true;
  final CompanyService apiService = CompanyService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchAllReviews();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('full_names') ?? 'Alex';
    final firstName = fullName.split(' ').first;
    setState(() {
      name = firstName;
    });
  }
// Helper function to calculate the number of days ago
  String _calculateDaysAgo(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) {
      return 'Some time ago';
    }
    DateTime parsedDate = DateTime.parse(createdAt);
    DateTime now = DateTime.now();
    int daysDifference = now.difference(parsedDate).inDays;
    return '$daysDifference day${daysDifference != 1 ? 's' : ''}';
  }

  Future<void> _fetchAllReviews() async {
    try {
      final reviews = await apiService.fetchAllReviews();
      setState(() {
        allReviews = reviews;
        _filterLatestReviews(); // Apply filtering after fetching
        isLoadingReviews = false;
      });
    } catch (e) {
      print('Error fetching reviews: $e');
      setState(() {
        isLoadingReviews = false;
      });
    }
  }

  void _filterLatestReviews() {
    filteredReviews = List.from(allReviews); // Start with all reviews
    filteredReviews.sort((a, b) => DateTime.parse(b['created_at']).compareTo(DateTime.parse(a['created_at'])));
    filteredReviews = filteredReviews.take(10).toList(); // Take the latest 10
  }

  final List<Map<String, String>> categories = [
    {'title': 'Tech', 'description': 'Our goal is to help you achieve a balanced lifestyle ', 'image': 'assets/tech.png'},
    {'title': 'Wellness', 'description': 'Our goal is to help you achieve a balanced lifestyle ', 'image': 'assets/wellness.png'},
    {'title': 'Finance', 'description': 'Our goal is to help you achieve a balanced lifestyle ', 'image': 'assets/finance.png'},
    {'title': 'Home Electronics', 'description': 'Our goal is to help you achieve a balanced lifestyle ', 'image': 'assets/electronics.png'},
  ];

  void _navigateToSubcategories(String categoryTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubcategoriesScreen(categoryTitle: categoryTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String heading = name.isNotEmpty ? 'Hi, $name!' : 'Hi!';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: SafeArea(
          child: HeaderWidget(
            heading: "Welcome!",
            showLogo: true, // Show logo
            showNotificationIcon: true, // Show notification icon
            showHeading: false,
            showSearchBar: false,
            showLine: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 8),
                Text(
                  'Categories',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 25 / 20,
                    letterSpacing: 0.38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                CategoriesWidget(
                  selectedBoxIndex: selectedBoxIndex,
                  onBoxSelected: (index) {
                    setState(() {
                      selectedBoxIndex = index;
                    });
                    _navigateToSubcategories(categories[index]['title'] ?? '');
                  },
                  categories: categories,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.165,
            minChildSize: 0.165,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 0.0, top: 20.0),
                decoration: BoxDecoration(
                  color: Color(0xFFEDEDED),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The latest reviews about services',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 25 / 20,
                          letterSpacing: -0.58,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      isLoadingReviews
                          ? Center(child: CircularProgressIndicator())
                          : filteredReviews.isEmpty
                          ? Center(child: Text('No reviews found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)))
                          : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredReviews.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          final review = filteredReviews[index];
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
                            showShareButton: false,
                            onTap: () {
                              print('ReviewCard tapped: ${review['org_name']}');
                            },
                            onLike: () {
                              setState(() {
                                review['isLiked'] = !(review['isLiked'] ?? false);
                                review['likes'] = (review['likes'] ?? 0) + (review['isLiked'] ? 1 : -1);
                              });
                            },
                            onShare: () {
                              Share.share(
                                'Check out this review: "${review['reviewText']}"',
                                subject: 'Review of ${review['title']}',
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
