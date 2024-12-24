import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/categories.dart';
import 'package:thrive_hub/widgets/top_bar.dart'; // Import your new HeaderWidget file
import 'package:thrive_hub/screens/user/search_screens/sub_categories_screen.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
     _loadUserData();
  }

  String name = ''; // Replace with the actual name variable or dynamic input
  int selectedBoxIndex = -1;

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final fullName = prefs.getString('access_token') ?? 'Alex';
    final firstName = fullName.split(' ').first;
    setState(() {
      name = firstName;
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     _loadUserData();
  }

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

  final List<Map<String, String>> categories = [
    {'title': 'Tech', 'description': 'Our goal is to help you achieve a balanced lifestyle '},
    {'title': 'Wellness', 'description': 'Our goal is to help you achieve a balanced lifestyle '},
    {'title': 'Finance', 'description': 'Our goal is to help you achieve a balanced lifestyle '},
    {'title': 'Home Electronics', 'description': 'Our goal is to help you achieve a balanced lifestyle '},
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
        preferredSize: Size.fromHeight(121),
        child: SafeArea(
          child: HeaderWidget(
            heading: heading,
            showHeading: true,
            showSearchBar: true,
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
                    height: 25/20,
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
                padding: EdgeInsets.only(left: 16.0,right: 16.0,bottom: 0.0,top: 20.0),
                // padding: EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: Color(0xFFEDEDED),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black26,
                  //     blurRadius: 10,
                  //     spreadRadius: 1,
                  //   ),
                  //
                  // ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 30),
                      Text(
                        'The latest reviews about services',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 25/20,
                          letterSpacing: -0.58,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allReviews.length,
                        controller: scrollController,
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
                            showShareButton: false,
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
