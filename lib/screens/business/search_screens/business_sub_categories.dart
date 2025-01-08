import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/search_screens/business_all_categories.dart';
import 'package:thrive_hub/screens/business/search_screens/business_services_screen.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/sub_categories.dart';
import 'package:thrive_hub/widgets/search_bar.dart';

class BusinessSubcategoriesScreen extends StatefulWidget {
  final String categoryTitle;

  const BusinessSubcategoriesScreen({Key? key, required this.categoryTitle}) : super(key: key);

  @override
  _BusinessSubcategoriesScreenState createState() => _BusinessSubcategoriesScreenState();
}

class _BusinessSubcategoriesScreenState extends State<BusinessSubcategoriesScreen> {
  List<Map<String, dynamic>> categoriesData = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    try {
      CompanyService companyService = CompanyService();
      final List<dynamic> fetchedCompanies = await companyService.fetchCompanyList();

      setState(() {
        // Dynamically filter out categories with no items
        categoriesData = [
          {
            "title": "Top Companies",
            "items": (fetchedCompanies
                .toList() // Convert to List to enable sorting
              ..sort((a, b) => (b['avg_rating'] ?? 0).compareTo(a['avg_rating'] ?? 0))) // Sort by avg_rating descending
                .map((e) => {
              "name": (e['org_name'] ?? "Unknown").toString(),
              "logoUrl": (e['logo_url'] ?? "").toString(),
              "business_profile_id": (e['business_profile_id'] ?? "-1").toString(),
              "rating": (e['avg_rating'] ?? 0).toString(), // Include rating if needed
            })
                .toList(), // Convert back to a list after mapping
          },
          {
            "title": "Tech",
            "items": fetchedCompanies
                .where((company) => company['category'] == 'Tech')
                .map((e) => {
              "name": (e['org_name'] ?? "Unknown").toString(),
              "logoUrl": (e['logo_url'] ?? "").toString(),
              "business_profile_id": (e['business_profile_id'] ?? "-1").toString(),
            })
                .toList(),
          },
          {
            "title": "Wellness",
            "items": fetchedCompanies
                .where((company) => company['category'] == 'Wellness')
                .map((e) => {
              "name": (e['org_name'] ?? "Unknown").toString(),
              "logoUrl": (e['logo_url'] ?? "").toString(),
              "business_profile_id": (e['business_profile_id'] ?? "-1").toString(),
            })
                .toList(),
          },
          {
            "title": "Finance",
            "items": fetchedCompanies
                .where((company) => company['category'] == 'Finance')
                .map((e) => {
              "name": (e['org_name'] ?? "Unknown").toString(),
              "logoUrl": (e['logo_url'] ?? "").toString(),
              "business_profile_id": (e['business_profile_id'] ?? "-1").toString(),
            })
                .toList(),
          },
          {
            "title": "Electronics",
            "items": fetchedCompanies
                .where((company) =>
            company['category'] == 'Electronics' || company['category'] == 'Home Electronic')
                .map((e) => {
              "name": (e['org_name'] ?? "Unknown").toString(),
              "logoUrl": (e['logo_url'] ?? "").toString(),
              "business_profile_id": (e['business_profile_id'] ?? "-1").toString(),
            })
                .toList(),
          },

        ]
            .where((category) => (category['items'] as List).isNotEmpty) // Filter out empty categories
            .toList();

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
        preferredSize: const Size.fromHeight(75),
        child: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 75,
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
      ),
      backgroundColor: Color(0xFFF0F0F0),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text('Error: $errorMessage'))
          : Container(
        color: const Color(0xFFF0F0F0),
        child: ListView.builder(
          itemCount: categoriesData.length,
          itemBuilder: (context, index) {
            final category = categoriesData[index];
            final String title = category['title'] ?? "Unknown Category";
            final List<Map<String, String>> items =
            List<Map<String, String>>.from(category['items']);

            return Column(
              children: [
                SubcategoriesWidget(
                  categoryTitle: title,
                  items: items,
                  onItemTap: (itemIndex) {
                    final selectedItem = items[itemIndex];
                    final business_profile_id = (selectedItem['business_profile_id']?? "-1").toString();

                    if (business_profile_id == "-1") {
                      // Show a loader or handle no action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile unavailable")),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessServicesScreen(business_profile_id: business_profile_id),
                      ),
                    );
                  },
                  onSeeAllTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusinessAllCategoriesScreen(
                          categoryTitle: title,
                        ),
                      ),
                    );
                  },
                  containerColor: index == 0
                      ? const Color(0xFFF0F0F0)
                      : Colors.white,
                  dropBoxColor: index == 0
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFFE9E8E8),
                ),
                const SizedBox(height: 4), // Spacing between rows
              ],
            );
          },
        ),
      ),
    );
  }
}
