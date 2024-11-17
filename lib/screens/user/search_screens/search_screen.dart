import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:thrive_hub/widgets/categories.dart';
import 'package:thrive_hub/widgets/top_bar.dart'; // Import your new HeaderWidget file
import 'package:thrive_hub/screens/user/search_screens/sub_categories_screen.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  int selectedBoxIndex = -1;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(121),
        child: SafeArea(
          child: HeaderWidget(
            heading: 'Hi, Olivia!',
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
                SizedBox(height: 1),
                Text(
                  'Categories',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: Color(0xFFEDEDED),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),

                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'The latest reviews about services',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return ReviewCard(
                            imageUrl: 'https://via.placeholder.com/40',
                            title: 'Company $index',
                            rating: 4.8,
                            location: 'USA',
                            timeAgo: '1 day ago',
                            reviewerName: 'Reviewer $index',
                            reviewText: 'This is a review for company $index. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            likes: 43,
                            showShareButton: false,
                            onLike: () {
                              setState(() {
                                // Handle like action here
                              });
                            },
                            onShare: () {
                              // Handle share action here
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
