import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/company_card.dart';

class BusinessSearchScreen extends StatefulWidget {
  @override
  _BusinessSearchScreenState createState() => _BusinessSearchScreenState();
}

class _BusinessSearchScreenState extends State<BusinessSearchScreen> {
  bool isSavedSelected = true; // Initially, Saved button is selected

  // Sample data for saved and history companies
  final List<Map<String, dynamic>> savedCompanies = List.generate(
    10,
        (index) => {
      'imageUrl': 'https://via.placeholder.com/93',
      'title': 'Company $index',
      'rating': 4.8,
      'reviews': 4123,
      'service': '',
      'description': 'Our goal is to help you achieve a balanced lifestyle, improve your overall health, and enhance your quality of life. $index',
      'isBookmarked': true,
    },
  );

  final List<Map<String, dynamic>> historyCompanies = List.generate(
    10,
        (index) => {
      'imageUrl': 'https://via.placeholder.com/93',
      'title': 'History Company $index',
      'rating': 4.5,
      'reviews': 3000,
      // 'service': 'Cloud Services',
      'description': 'Description for history company $index',
      'isBookmarked': false,
    },
  );

  @override
  Widget build(BuildContext context) {
    final companies = isSavedSelected ? savedCompanies : historyCompanies;

    return Scaffold(
      appBar: CustomAppBar(title: 'My Companies', showBackButton: false, centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Text(
              'Best Companies on Your Category',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                height: 1.25, // Equivalent to a 25px line height
                letterSpacing: 0.38,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 8.0), // Space between heading and the list
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
