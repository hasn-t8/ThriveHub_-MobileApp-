import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/company_card.dart'; // Import the CompanyCard widget
import 'package:thrive_hub/widgets/appbar.dart';
import '../../../widgets/tab_buttons.dart';

class MyCompaniesScreen extends StatefulWidget {
  @override
  _MyCompaniesScreenState createState() => _MyCompaniesScreenState();
}

class _MyCompaniesScreenState extends State<MyCompaniesScreen> {
  bool isSavedSelected = true; // Initially, Saved button is selected

  // Sample data for saved and history companies
  final List<Map<String, dynamic>> savedCompanies = List.generate(
    10,
        (index) => {
      'imageUrl': 'https://via.placeholder.com/93',
      'title': 'BlueHost $index',
      'rating': 4.8,
      'reviews': 4123,
      'service': 'Web Hosting Services',
      'description': 'Our goal is to help you achieve a balanced lifestyle, improve your overall health, and enhance your quality of life. $index',
      'isBookmarked': true,
    },
  );

  final List<Map<String, dynamic>> historyCompanies = List.generate(
    10,
        (index) => {
      'imageUrl': 'https://via.placeholder.com/93',
      'title': 'HostGator $index',
      'rating': 4.5,
      'reviews': 3000,
      'service': 'Cloud Services',
      'description': 'Our goal is to help you achieve a balanced lifestyle, improve your overall health, and enhance your quality of life. $index',
      'isBookmarked': false,
    },
  );

  @override
  Widget build(BuildContext context) {
    final companies = isSavedSelected ? savedCompanies : historyCompanies;

    return Scaffold(
      appBar: CustomAppBar(title: 'My Companies', showBackButton: true, centerTitle: true),
      body: Container(
        color: Color(0xFFFFFFFF), // Set the background color to white
        child: Column(
          children: [
            SizedBox(height: 10.0), // Space between AppBar and buttons
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
              allText: 'Saved',
              myReviewsText: 'History',
            ),
            SizedBox(height: 8.0), // Space between buttons and cards
            Expanded(
              child: ListView.builder(
                itemCount: companies.length, // Use dynamic data length
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
                      print('CompanyCard tapped: ${company['title']}');
                      // Navigate to another screen or perform an action
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
