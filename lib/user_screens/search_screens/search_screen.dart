import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/categories.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int selectedBoxIndex = -1;

  final List<Map<String, String>> categories = [
    {'title': 'Category 1', 'description': 'Description for category 1'},
    {'title': 'Category 2', 'description': 'Description for category 2'},
    {'title': 'Category 3', 'description': 'Description for category 3'},
    {'title': 'Category 4', 'description': 'Description for category 4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFE9E9EA),
            hintText: 'Search',
            hintStyle: TextStyle(color: Color(0xFFBFBFBF)),
            prefixIcon: Icon(Icons.search, color: Color(0xFFBFBFBF)),
            suffixIcon: Icon(Icons.mic, color: Color(0xFFBFBFBF)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main content scroll view
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 26),
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
                SizedBox(height: 26),
                CategoriesWidget(
                  selectedBoxIndex: selectedBoxIndex,
                  onBoxSelected: (index) {
                    setState(() {
                      selectedBoxIndex = index;
                    });
                  },
                  categories: categories,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          // DraggableScrollableSheet for bottom sheet reviews section
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 5,
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
                      SizedBox(height: 36),
                      // List of review cards
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
                            reviewText:
                            'This is a review for company $index. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                            likes: 43,
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
