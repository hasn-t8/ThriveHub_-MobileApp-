import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/search_screens/services_screen.dart';
import 'package:thrive_hub/screens/search_screens/filter_screen.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/search_bar.dart';
import 'package:thrive_hub/widgets/categories_top_bar.dart';
import 'package:thrive_hub/widgets/filter_sort_buttons.dart';
import 'package:thrive_hub/widgets/company_card.dart';
import 'package:thrive_hub/widgets/sort.dart';

class AllCategoriesScreen extends StatefulWidget {
  final String categoryTitle;
  const AllCategoriesScreen({Key? key, this.categoryTitle = ''})
      : super(key: key);

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  List<dynamic> companies = []; // List to hold all companies from API
  List<dynamic> filteredCompanies = []; // List to hold filtered companies
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // For error handling
  String selectedCategory = 'All'; // Track the currently selected category

  @override
  void initState() {
    super.initState();
    _fetchCompanyList(title: widget.categoryTitle);
  }

  // // Fetch the company list from the API
  // void _fetchCompanyList() async {
  //   try {
  //     CompanyService companyService = CompanyService();
  //     List<dynamic> fetchedCompanies = await companyService.fetchCompanyList();
  //     setState(() {
  //       companies = fetchedCompanies;
  //       filteredCompanies = fetchedCompanies; // Initially show all companies
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //       errorMessage = e.toString();
  //       print('$errorMessage');
  //     });
  //   }
  // }
  // Fetch the company list from the API
  void _fetchCompanyList({String? title}) async {
    try {
      CompanyService companyService = CompanyService();
      List<dynamic> fetchedCompanies = await companyService.fetchCompanyList();

      // Filter and sort companies based on title
      List<dynamic> filtered;

      if (title != null && title.isNotEmpty) {
        if (title.toLowerCase() == 'top companies') {
          // Show companies with high ratings sorted from high to low
          filtered = fetchedCompanies
              .where((company) => company['avg_rating'] != null)
              .toList()
            ..sort((a, b) => (b['avg_rating'] ?? 0).compareTo(a['avg_rating'] ?? 0));
        } else {
          // Filter companies by category
          filtered = fetchedCompanies.where((company) {
            return company['category'] != null &&
                company['category']
                    .toString()
                    .toLowerCase()
                    .contains(title.toLowerCase());
          }).toList();
        }
      } else {
        // No title provided, show all companies
        filtered = fetchedCompanies;
      }

      setState(() {
        companies = fetchedCompanies;
        filteredCompanies = filtered; // Update filtered companies
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
  // Apply filters based on selected criteria
  void applyFilters(List<String> filters) {
    print('Applying filters:');
    setState(() {
      // If no filters are applied, show all companies
      if (filters.isEmpty) {
        filteredCompanies = List.from(companies);
        return;
      }

      // If "All" is in the filters, show all companies
      if (filters.contains('All')) {
        filteredCompanies = List.from(companies);
        return;
      }

      // Separate ratings and categories from filters
      List<double> selectedRatings = filters
          .where((filter) => RegExp(r'^\d$').hasMatch(filter)) // Numeric ratings like 2, 3, 4, 5
          .map((rating) => double.tryParse(rating)!)
          .toList();

      List<String> selectedCategories = filters
          .where((filter) => !RegExp(r'^\d$').hasMatch(filter)) // Non-numeric categories
          .toList();

      if (selectedRatings.isNotEmpty) {
        // Filter by ratings only
        filteredCompanies = companies.where((company) {
          double companyRating =
          (double.tryParse(company['avg_rating']?.toString() ?? '0') ?? 0)/2;
          return selectedRatings.contains(companyRating); // Match selected ratings
        }).toList();
      } else if (selectedCategories.isNotEmpty) {
        // Filter by categories only
        filteredCompanies = companies.where((company) {
          final companyCategory = company['category']?.toLowerCase();
          return selectedCategories.any((filter) => companyCategory == filter.toLowerCase());
        }).toList();
      }

      // Log the filtered companies
      print('Filtered Companies: ${filteredCompanies.map((c) => c['org_name']).toList()}');
    });
  }



  // Apply sorting based on selected criteria
  void applySort(String sortOption) {
    setState(() {
      filteredCompanies.sort((a, b) {
        switch (sortOption) {
          case 'Rating':
            return (b['avg_rating'] ?? 0.0).compareTo(a['avg_rating'] ?? 0.0);
          case 'Newest':
          // Proper date parsing and sorting
            DateTime dateA = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(1970);
            DateTime dateB = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(1970);
            return dateB.compareTo(dateA); // Descending order
          default:
            return 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.categoryTitle);
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
                  imageUrl: company['logo_url'] ?? 'https://cdn.pixabay.com/photo/2019/03/13/14/08/building-4052951_640.png',
                  title: company['org_name'] ?? 'Unknown',
                  rating: (double.tryParse(company['avg_rating'] ?? '0.0') ?? 0.0)/2,
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
                              ServicesScreen(business_profile_id: businessProfileId),
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
