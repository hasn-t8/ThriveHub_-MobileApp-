import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/search_screens/business_services_screen.dart';
import 'package:thrive_hub/screens/user/search_screens/filter_screen.dart';
import 'package:thrive_hub/widgets/search_bar.dart'; // Adjust the import path for your reusable search bar
import 'package:thrive_hub/widgets/categories_top_bar.dart'; // Import CategoriesTopBar
import 'package:thrive_hub/widgets/filter_sort_buttons.dart'; // Import the FilterSortButtons widget
import 'package:thrive_hub/widgets/company_card.dart';
import 'package:thrive_hub/widgets/sort.dart'; // Import the CompanyCard widget

class BusinessAllCategoriesScreen extends StatefulWidget {
  final String categoryTitle;
  final List<String> items;

  const BusinessAllCategoriesScreen({Key? key, required this.categoryTitle, required this.items})
      : super(key: key);

  @override
  _BusinessAllCategoriesScreenState createState() => _BusinessAllCategoriesScreenState();
}

class _BusinessAllCategoriesScreenState extends State<BusinessAllCategoriesScreen> {
  // Mock companies data
  final List<Map<String, dynamic>> companies = List.generate(10, (index) {
    return {
      'imageUrl': 'https://via.placeholder.com/93',
      'title': 'Saved Company $index',
      'rating': 4.8,
      'reviews': 4123,
      'service': 'Web Hosting Services',
      'description':
      'Our goal is to help you achieve a balanced lifestyle, improve your overall health, and enhance your quality of life. $index',
      'isBookmarked': false,
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(125),
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              // toolbarHeight: 75,
              backgroundColor: Colors.white,
              elevation: 0,
              title: CustomSearchBar(
                onBackButtonPressed: () {
                  Navigator.pop(context);
                },
                onSearchChanged: (value) {
                  print('Search input: $value');
                },
              ),
            ),
            CategoriesTopBar(
              categories: ['Tech', 'Design', 'Science', 'Art', 'Music', 'Finance'],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          FilterSortButtons(
            onFilter: (context) async {
              // Your filter logic here
              return await Navigator.push<List<String>>(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              ) ?? [];
            },
            onSort: (context) async {
              // Your sort logic here
              return await showModalBottomSheet<String>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const SortBottomSheet(
                  title: 'Sort By', // Pass custom title
                  sortOptions: ['Price Low to High', 'Price High to Low', 'Rating', 'Newest'], // Pass custom options

                ),
              );
            },
          ),

          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return CompanyCard(
                  imageUrl: company['imageUrl'],
                  title: company['title'],
                  rating: company['rating'],
                  reviews: company['reviews'],
                  service: company['service'],
                  description: company['description'],
                  isBookmarked: company['isBookmarked'],
                  onBookmarkToggle: () {
                    setState(() {
                      company['isBookmarked'] = !company['isBookmarked'];
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessServicesScreen(),
                      ),
                    );
                    print('CompanyCard tapped: ${company['title']}');
                    // Navigate to another screen or perform an action
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
