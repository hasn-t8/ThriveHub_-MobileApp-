import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/company_card.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import '../../../widgets/tab_buttons.dart';

class MyCompaniesScreen extends StatefulWidget {
  @override
  _MyCompaniesScreenState createState() => _MyCompaniesScreenState();
}

class _MyCompaniesScreenState extends State<MyCompaniesScreen> {
  bool isSavedSelected = true;
  List<dynamic> savedCompanies = []; // List of bookmarked companies
  List<dynamic> visitedCompanies = []; // List of visited companies
  Set<int> bookmarkedIds = {}; // Set of bookmarked business IDs
  bool isLoading = true;
  String errorMessage = '';

  final CompanyService companyService = CompanyService();

  // Fetch company list from API
  void _fetchCompanyList() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Fetch the list of companies
      List<dynamic> fetchedCompanies = await companyService.fetchCompanyList();

      // Retrieve the list of visited business IDs from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> visitedBusinessIds = prefs.getStringList('visitedBusinessIds') ?? [];

      // Keep only the latest 500 visited businesses
      if (visitedBusinessIds.length > 500) {
        visitedBusinessIds = visitedBusinessIds.skip(100).toList();
        await prefs.setStringList('visitedBusinessIds', visitedBusinessIds);
      }

      // Fetch bookmarked business IDs from API
      List<int>? bookmarkedBusinessIds = await companyService.getBookmarkedBusinesses();
      bookmarkedIds = bookmarkedBusinessIds?.toSet() ?? {};

      setState(() {
        // Filter visited companies
        visitedCompanies = fetchedCompanies
            .where((company) => visitedBusinessIds.contains(company['id'].toString()))
            .take(500)
            .toList();

        // Filter saved (bookmarked) companies
        savedCompanies = fetchedCompanies
            .where((company) => bookmarkedIds.contains(company['id']))
            .take(500)
            .toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });

      print('Error fetching company list: $e');
    }
  }

  // Toggle bookmark status & refresh both lists
  void _toggleBookmark(int businessId) async {
    bool success = await companyService.bookmarkBusiness(businessId);
    if (success) {
      _fetchCompanyList(); // Refresh both saved & history lists
    } else {
      print("Failed to update bookmark status for business ID: $businessId");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCompanyList();
  }

  @override
  Widget build(BuildContext context) {
    final companies = isSavedSelected ? savedCompanies : visitedCompanies;

    return Scaffold(
      appBar: CustomAppBar(title: 'My Companies', showBackButton: true, centerTitle: true),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 10.0),
            TabButtons(
              isAllSelected: isSavedSelected,
              onSelectAll: () {
                setState(() => isSavedSelected = true);
                _fetchCompanyList();
              },
              onSelectMyReviews: () {
                setState(() => isSavedSelected = false);
                _fetchCompanyList();
              },
              allText: 'Saved',
              myReviewsText: 'History',
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                  ? Center(
                child: Text(
                  'Error: $errorMessage',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
                  : companies.isEmpty
                  ? Center(
                child: Text(
                  isSavedSelected ? 'No saved companies found' : 'No company history found',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
                  : ListView.builder(
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return CompanyCard(
                    imageUrl: company['logo_url'] ??
                        'https://cdn.pixabay.com/photo/2019/03/13/14/08/building-4052951_640.png',
                    title: company['org_name'] ?? 'No Title',
                    rating: (double.tryParse(company['avg_rating'] ?? '0.0') ?? 0.0) / 2,
                    reviews: company['total_reviews'] ?? 0,
                    service: company['category'] ?? 'No Service Info',
                    description: company['about_business'] ?? 'No Description',
                    isBookmarked: bookmarkedIds.contains(company['id']),
                    onBookmarkToggle: () => _toggleBookmark(company['id']),
                    onTap: () {
                      print('CompanyCard tapped: ${company['org_name']}');
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
