import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_category_screen.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_company_logo_screen.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_about_screen.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_verify_screen.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_code_verify_screen.dart';

class SliderScreen extends StatefulWidget {
  @override
  _SliderScreenState createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedCategory = '';

  // List of titles for each screen
  final List<String> _titles = [
    'Category',
    'Company Logo',
    'About Us',
    'Verify',
    'Code',
  ];

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _goToNextPage() {

    // Move to the next page directly
    if (_currentPage < 4) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _titles[_currentPage],  // Set title based on current page index
        showBackButton: true,
        centerTitle: true,

      ),
      body: Column(
        children: [
          // Progress Indicator (Slider Bar)
          Container(
            height: 4,
            child: Row(
              children: List.generate(4, (index) {
                return Expanded(
                  child: Container(
                    color: index <= _currentPage ? Colors.blue : Color(0xFFDEDEDE),
                  ),
                );
              }),
            ),
          ),

          // PageView with Screens
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),  // Disable swiping
              children: [
                BusinessCategoryScreen(onCategorySelected: _onCategorySelected , goToNextPage: _goToNextPage,),
                BusinessCompanyLogoScreen(onNext: _goToNextPage),
                BusinessAboutScreen(onSkip: _goToNextPage,onNext: _goToNextPage), // Pass the onSkip function to AboutScreen
                BusinessVerifyScreen(onNext: _goToNextPage,),
                BusinessCodeVerifyScreen(onDone: _goToNextPage ,onResendCode: _goToNextPage,),
              ],
            ),
          ),

          // Continue Buttons
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: ElevatedButton(
          //       onPressed: _selectedCategory.isNotEmpty || _currentPage > 0
          //           ? () {
          //         // Go to the next page when "Continue" is pressed
          //         if (_currentPage < 4) {
          //           setState(() {
          //             _currentPage++;
          //           });
          //           _pageController.animateToPage(
          //             _currentPage,
          //             duration: Duration(milliseconds: 300),
          //             curve: Curves.easeInOut,
          //           );
          //         }
          //       }
          //           : null,
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: _selectedCategory.isNotEmpty || _currentPage > 0
          //             ? Color(0xFF828282)
          //             : Colors.grey,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         minimumSize: Size(double.infinity, 56),
          //       ),
          //       child: Text(
          //         'Continue',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
