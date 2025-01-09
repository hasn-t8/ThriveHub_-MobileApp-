import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/search_screens/business_services_screen.dart';
import 'package:thrive_hub/screens/user/search_screens/filter_screen.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/search_bar.dart';
import 'package:thrive_hub/widgets/categories_top_bar.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';
import 'package:thrive_hub/widgets/company_card.dart';
import 'package:thrive_hub/widgets/sort.dart';

class BusinessAllCategoriesScreen extends StatefulWidget {
  final String categoryTitle;
  const BusinessAllCategoriesScreen({Key? key, this.categoryTitle = ''})
      : super(key: key);

  @override
  _BusinessAllCategoriesScreenState createState() => _BusinessAllCategoriesScreenState();
}

class _BusinessAllCategoriesScreenState extends State<BusinessAllCategoriesScreen> {
  List<dynamic> companies = []; // List to hold all companies from API
  List<dynamic> filteredCompanies = []; // List to hold filtered companies
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // For error handling
  String selectedCategory = 'All'; // Track the currently selected category

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
        filteredCompanies = fetchedCompanies; // Initially show all companies
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

  // Filter companies based on selected category
  void _filterCompanies(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredCompanies = companies; // Show all companies if "All" is selected
      } else {
        filteredCompanies = companies
            .where((company) =>
        company['category']?.toLowerCase() == category.toLowerCase())
            .toList();
      }
    });
  }

  // Apply filters based on selected criteria
  void applyFilters(List<String> filters) {
    print('Applying filters:');
    setState(() {
      if (filters.isEmpty) {
        // If no filters are applied, show all companies
        filteredCompanies = List.from(companies);
      } else {
        print('Applying filters: $filters'); // Log the filters being applied
        filteredCompanies = companies.where((company) {
          final companyCategory = company['category']?.toLowerCase();
          final matchesFilter = filters.any((filter) => companyCategory == filter.toLowerCase());

          // Log each company's category and whether it matches any filter
          print('Company Category: $companyCategory, Matches Filter: $matchesFilter');
          return matchesFilter;
        }).toList();
      }
    });

    // Log the filtered companies after filtering
    print('Filtered Companies: ${filteredCompanies.map((c) => c['org_name']).toList()}');
  }


  // Apply sorting based on selected criteria
  void applySort(String sortOption) {
    setState(() {
      filteredCompanies.sort((a, b) {
        switch (sortOption) {
          case 'Rating':
            return (b['avg_rating'] ?? 0.0).compareTo(a['avg_rating'] ?? 0.0);
          case 'Newest':
            return (b['created_at'] ?? '').compareTo(a['created_at'] ?? '');
          default:
            return 0;
        }
      });
    });
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
                  setState(() {
                    if (value.isEmpty) {
                      filteredCompanies = companies; // Show all companies if search input is empty
                    } else {
                      filteredCompanies = companies
                          .where((company) =>
                      company['org_name']?.toLowerCase().contains(value.toLowerCase()) ?? false)
                          .toList();
                    }
                  });
                },
              ),
            ),
            CategoriesTopBar(
              categories: ['All', 'Tech', 'Wellness', 'Finance', 'Electronics'],
              initialSelectedCategory: selectedCategory, // Pass initial category
              onCategorySelected: (selectedCategory) {
                _filterCompanies(selectedCategory); // Filter on selection
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FilterSortButtons(
            onFilter: (context) async {
              final filters = await Navigator.push<List<String>>(
                context,
                MaterialPageRoute(builder: (context) => FilterScreen()),
              );
              if (filters != null) {
                applyFilters(filters); // Apply the filters to your data
              }

              return filters ?? []; // Ensure the correct type is returned
            },
            onSort: (context) async {
              final sortOption = await showModalBottomSheet<String>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => const SortBottomSheet(
                  title: 'Sort By',
                  sortOptions: ['Rating', 'Newest'],
                ),
              );

              if (sortOption != null && sortOption.isNotEmpty) {
                applySort(sortOption);
              }

              return sortOption ?? '';
            },
            onFiltersUpdated: (updatedFilters) {
              applyFilters(updatedFilters);
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text('Error: $errorMessage'))
                : ListView.builder(
              itemCount: filteredCompanies.length,
              itemBuilder: (context, index) {
                final company = filteredCompanies[index];
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
                    final businessProfileId = company['business_profile_id']?.toString();
                    if (businessProfileId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BusinessServicesScreen(business_profile_id: businessProfileId),
                        ),
                      );
                    } else {
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
