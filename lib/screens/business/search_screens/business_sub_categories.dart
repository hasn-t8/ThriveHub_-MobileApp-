import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/search_screens/business_all_categories.dart';
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
        // Group companies into hardcoded categories and assign items dynamically
        categoriesData = [
          {
            "title": "Tech",
            "items": fetchedCompanies.map((e) => e['org_name'] ?? "Unknown").toList(),
          },
          {
            "title": "Will Ness",
            "items": fetchedCompanies.map((e) => e['org_name'] ?? "Unknown").toList(),
          },
          {
            "title": "Finance",
            "items": fetchedCompanies.map((e) => e['org_name'] ?? "Unknown").toList(),
          },
          {
            "title": "Electronics",
            "items": fetchedCompanies.map((e) => e['org_name'] ?? "Unknown").toList(),
          },
        ];
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
            final String title = category['title'];
            final List<String> items = List<String>.from(category['items']);

            return Column(
              children: [
                SubcategoriesWidget(
                  categoryTitle: title,
                  items: items,
                  onItemTap: (itemIndex) {
                    print('Tapped item: ${items[itemIndex]} in $title');
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
                  containerColor: index == 0 ? const Color(0xFFF0F0F0) : Colors.white,
                  dropBoxColor: index == 0 ? const Color(0xFFFFFFFF) : const Color(0xFFE9E8E8),
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
