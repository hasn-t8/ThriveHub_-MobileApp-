import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/search_screens/business_all_categories.dart';
import 'package:thrive_hub/screens/business/search_screens/business_services_screen.dart';
import 'package:thrive_hub/screens/user/search_screens/all_categories.dart';
import 'package:thrive_hub/widgets/sub_categories.dart';
import 'package:thrive_hub/widgets/search_bar.dart'; // Adjust the import path for your reusable search bar
import 'package:thrive_hub/widgets/categories_top_bar.dart'; // Import CategoriesTopBar

class BusinessSubcategoriesScreen extends StatelessWidget {
  final String categoryTitle;

  BusinessSubcategoriesScreen({Key? key, required this.categoryTitle}) : super(key: key);

  // Mock data to simulate API response
  final List<Map<String, dynamic>> mockCategoriesData = [
    {
      "title": "Category 1",
      "items": ["Dropbox", "Google Drive", "OneDrive", "iCloud"]
    },
    {
      "title": "Category 2",
      "items": ["Box", "Mega", "CloudApp", "Amazon S3"]
    },
    {
      "title": "Category 3",
      "items": ["SharePoint", "iDrive", "pCloud", "Backblaze"]
    },
    {
      "title": "Category 4",
      "items": ["SharePoint", "iDrive", "pCloud", "Backblaze"]
    },
    {
      "title": "Category 5",
      "items": ["SharePoint", "iDrive", "pCloud", "Backblaze"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // Adjust height to include both widgets
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false, // Disable default back button
              // toolbarHeight: 75, // Height for the search bar
              backgroundColor: Colors.white, // AppBar background color
              elevation: 0, // Remove shadow
              title: CustomSearchBar(
                onBackButtonPressed: () {
                  Navigator.pop(context); // Navigate back
                },
                onSearchChanged: (value) {
                  print('Search input: $value');
                  // Implement search functionality here
                },
              ),
            ),
            // Add CategoriesTopBar below the Search Bar
            CategoriesTopBar(
              categories: ['Tech', 'Design', 'Science', 'Art', 'Music', 'Finance'],
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFFF0F0F0), // Background color for the whole screen
        child: ListView.builder(
          itemCount: mockCategoriesData.length,
          itemBuilder: (context, index) {
            final category = mockCategoriesData[index];
            final String title = category['title'];
            final List<String> items = List<String>.from(category['items']);

            return Column(
              children: [
                SubcategoriesWidget(
                  categoryTitle: title,
                  items: items,
                  onItemTap: (index) {
                    // Handle navigation based on the selected index
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessServicesScreen(),
                      ),
                    );
                    print('Tapped item at index: $index');
                  },
                  onSeeAllTap: () {
                    print("See All tapped for $title");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessAllCategoriesScreen(
                          categoryTitle: title,
                          items: items,
                        ),
                      ),
                    );
                  },
                  // For the first row, apply the specified colors
                  containerColor: index == 0 ? const Color(0xFFF0F0F0) : Colors.white,
                  dropBoxColor: index == 0 ? const Color(0xFFFFFFFF) : const Color(0xFFE9E8E8),
                ),
                const SizedBox(height: 4), //// Spacing between rows
              ],
            );
          },
        ),
      ),
    );
  }
}
