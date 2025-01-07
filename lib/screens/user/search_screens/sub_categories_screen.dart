import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/sub_categories.dart';
import 'package:thrive_hub/widgets/search_bar.dart'; // Adjust the import path for your reusable search bar
import 'package:thrive_hub/screens/business/search_screens/business_all_categories.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';

class SubcategoriesScreen extends StatefulWidget {
  final String categoryTitle;

  const SubcategoriesScreen({Key? key, required this.categoryTitle})
      : super(key: key);

  @override
  _SubcategoriesScreenState createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
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
        // Ensure consistent typing for items
        categoriesData = [
          {
            "title": "Tech",
            "items": fetchedCompanies
                .where((company) => company['category'] == 'Tech')
                .map((e) => {
              "name": (e['org_name'] ?? "Unknown").toString(),
              "logoUrl": (e['logo_url'] ?? "").toString(),
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
            })
                .toList(),
          },
          {
            "title": "Electronics",
            "items": fetchedCompanies
                .where((company) => company['category'] == 'Electronics')
                .map((e) => {
              "name": (e['org_name'] ?? "Unknown").toString(),
              "logoUrl": (e['logo_url'] ?? "").toString(),
            })
                .toList(),
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
                    print('Tapped item: ${selectedItem['name']} in $title');
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
