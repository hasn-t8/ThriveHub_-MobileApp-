import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/user/search_screens/filter_screen.dart';
import 'package:thrive_hub/screens/user/search_screens/services_screen.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/search_bar.dart';
import 'package:thrive_hub/widgets/categories_top_bar.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';
import 'package:thrive_hub/widgets/company_card.dart';
import 'package:thrive_hub/widgets/sort.dart';

class AllCategoriesScreen extends StatefulWidget {
  final String categoryTitle;
  final List<String> items;

  const AllCategoriesScreen({Key? key, required this.categoryTitle, required this.items})
      : super(key: key);

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
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
              categories: ['All','Tech', 'Wellness', 'Finance', 'Electronics'],
              // initialSelectedCategory: selectedCategory, // Pass initial category
              onCategorySelected: (selectedCategory) {
                // _filterCompanies(selectedCategory); // Filter on selection
              },
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
            onFiltersUpdated: (updatedFilters) {
              // Handle the updated filters in the parent widget
              print("Filters updated: $updatedFilters");
              // Optionally update additional UI or state here
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text('Error: $errorMessage'))
                : ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index];
                return CompanyCard(
                  imageUrl: company['logo_url'] ?? '', // Default empty string
                  title: company['org_name'] ?? 'Unknown Organization',
                  rating: company['rating'] ?? 0.0, // Default to 0.0 for ratings
                  reviews: company['reviews'] ?? 0, // Default to 0 for reviews
                  service: company['category'] ?? 'No Service',
                  description: company['about_business'] ?? 'No description available.',
                  isBookmarked: company['isBookmarked'] ?? false,
                  onBookmarkToggle: () {
                    setState(() {
                      company['isBookmarked'] = !(company['isBookmarked'] ?? false);
                    });
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ServicesScreen()),
                    );
                    print('CompanyCard tapped: ${company['org_name']}');
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
