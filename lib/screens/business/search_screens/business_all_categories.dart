import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/search_screens/business_services_screen.dart';
import 'package:thrive_hub/screens/user/search_screens/filter_screen.dart';
import 'package:thrive_hub/services/company_services/company_services.dart'; // Import CompanyService
import 'package:thrive_hub/widgets/search_bar.dart';
import 'package:thrive_hub/widgets/categories_top_bar.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';
import 'package:thrive_hub/widgets/company_card.dart';
import 'package:thrive_hub/widgets/sort.dart';

class BusinessAllCategoriesScreen extends StatefulWidget {
  final String categoryTitle;
  final List<String> items;

  const BusinessAllCategoriesScreen({Key? key, required this.categoryTitle, required this.items})
      : super(key: key);

  @override
  _BusinessAllCategoriesScreenState createState() => _BusinessAllCategoriesScreenState();
}

class _BusinessAllCategoriesScreenState extends State<BusinessAllCategoriesScreen> {
  List<dynamic> companies = []; // List to hold company data
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // For error handling

  @override
  void initState() {
    super.initState();
    _fetchCompanyList();
  }

  // Fetch the company list from the API
  void _fetchCompanyList() async {
    try {
      CompanyService companyService = CompanyService();
      List<dynamic> fetchedCompanies = await companyService.fetchCompanyList();
      setState(() {
        companies = fetchedCompanies;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
        print('$errorMessage');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(125),
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
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
              categories: ['Tech', 'Will Ness', 'Finance', 'Electronics'],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          FilterSortButtons(
            onFilter: (context) async {
              return await Navigator.push<List<String>>(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              ) ?? [];
            },
            onSort: (context) async {
              return await showModalBottomSheet<String>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const SortBottomSheet(
                  title: 'Sort By',
                  sortOptions: ['Price Low to High', 'Price High to Low', 'Rating', 'Newest'],
                ),
              );
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text('Error: $errorMessage'))
                : ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return CompanyCard(
                  imageUrl: company['logo_url'] ?? '',
                  title: company['org_name'] ?? 'Unknown',
                  rating: double.tryParse(company['avg_rating'] ?? '0.0') ?? 0.0,
                  reviews: company['total_reviews'] ?? 0,
                  service: company['category'] ?? 'No Service',
                  description: company['about_business'] ?? 'No description available.',
                  isBookmarked: company['isBookmarked'] ?? false,
                  onBookmarkToggle: () {
                    setState(() {
                      company['isBookmarked'] = !(company['isBookmarked'] ?? false);
                    });
                  },

                  onTap: () {
                    // final profileId = company['profile_id']; // Ensure 'profile_id' is available in your data
                    final profileId = company['profile_id']?.toString();
                     print("tab profile id is $profileId");
                    if (profileId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessServicesScreen(profileId: profileId),
                        ),
                      );
                      print('Navigating to BusinessServicesScreen with profileId: $profileId');
                    }
                    else {
                      print('Error: Profile ID is null for the selected company.');
                    }
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
