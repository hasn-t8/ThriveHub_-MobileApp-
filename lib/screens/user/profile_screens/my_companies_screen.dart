import 'package:flutter/material.dart';
import 'package:thrive_hub/services/company_services/company_services.dart';
import 'package:thrive_hub/widgets/company_card.dart'; // Import the CompanyCard widget
import 'package:thrive_hub/widgets/appbar.dart';
import '../../../widgets/tab_buttons.dart';

class MyCompaniesScreen extends StatefulWidget {
  @override
  _MyCompaniesScreenState createState() => _MyCompaniesScreenState();
}

class _MyCompaniesScreenState extends State<MyCompaniesScreen> {
  bool isSavedSelected = true; // Initially, Saved button is selected
  List<dynamic> allCompanies = []; // List to hold all companies from API
  List<dynamic> savedCompanies = []; // Companies with `bookmark: true`
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // For error handling

  // Fetch the company list from the API
  void _fetchCompanyList() async {
    try {
      CompanyService companyService = CompanyService();
      List<dynamic> fetchedCompanies = await companyService.fetchCompanyList();

      setState(() {
        allCompanies = fetchedCompanies;

        // Filter saved companies based on the `bookmark` tag
        savedCompanies = allCompanies.where((company) => company['bookmark'] == true).toList();

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
  void initState() {
    super.initState();
    _fetchCompanyList(); // Fetch the company list on initialization
  }

  @override
  Widget build(BuildContext context) {
    // Determine which list to display: Saved or History
    final companies = isSavedSelected ? savedCompanies : allCompanies;

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
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
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
                  isSavedSelected
                      ? 'No saved companies found'
                      : 'No company history found',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )
                  : ListView.builder(
                itemCount: companies.length, // Use dynamic data length
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return CompanyCard(
                    imageUrl: company['logo_url'] ?? 'https://cdn.pixabay.com/photo/2019/03/13/14/08/building-4052951_640.png',
                    title: company['org_name'] ?? 'No Title',
                    rating: (double.tryParse(company['avg_rating'] ?? '0.0') ?? 0.0) / 2,
                    reviews: company['total_reviews'] ?? 0,
                    service: company['category'] ?? 'No Service Info',
                    description: company['about_business'] ?? 'No Description',
                    isBookmarked: company['bookmark'] ?? false,
                    onBookmarkToggle: () {
                      setState(() {
                        company['bookmark'] = !(company['bookmark'] ?? false);
                        // Update savedCompanies dynamically
                        if (company['bookmark'] == true) {
                          savedCompanies.add(company);
                        } else {
                          savedCompanies.removeWhere((c) => c['id'] == company['id']);
                        }
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
