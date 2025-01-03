import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_about_screen.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_category_screen.dart';
import 'package:thrive_hub/screens/business/slider_screens/business_company_logo_screen.dart';
import 'package:thrive_hub/services/profile_service/profile_service.dart';
import 'package:thrive_hub/widgets/appbar.dart';

class BusinessSliderScreen extends StatefulWidget {

  BusinessSliderScreen();

  @override
  _BusinessSliderScreenState createState() => _BusinessSliderScreenState();
}

class _BusinessSliderScreenState extends State<BusinessSliderScreen> {
  late ProfileService _profileService;
  PageController _pageController = PageController();
  int _currentPage = 0;

  // Collected data
  String _selectedCategory = '';
  String? _companyLogoPath;
  String _aboutDescription = '';

  // List of titles for each screen
  final List<String> _titles = ['Category', 'Company Logo', 'About Us'];

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService(); // Initialize ProfileService without passing parameters

  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onLogoSelected(String logoPath) {
    setState(() {
      _companyLogoPath = logoPath;
    });
  }

  void _onDescriptionUpdated(String description) {
    setState(() {
      _aboutDescription = description;
    });
  }

  void _goToNextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitData();
    }
  }

  Future<void> _submitData() async {
    print('submit hit  ');
    if (_companyLogoPath == null) {
      print('No logo selected');
      return;
    }

    final File logoFile = File(_companyLogoPath!);
    final payload = {
      'category': _selectedCategory,
      'about_business': _aboutDescription,
    };
    print('data is ');
    print('data is $logoFile,$payload');
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // Perform API calls
    // final logoUploaded = await _profileService.businessUploadLogo(logoFile);
    // if (!logoUploaded) {
    //   Navigator.of(context).pop(); // Dismiss loading indicator
    //   print('Logo upload failed');
    //   return;
    // }

    final dataSent = await _profileService.businessProfileSetup(payload);
    Navigator.of(context).pop(); // Dismiss loading indicator

    if (dataSent) {
      print('All data sent successfully!');
      // Navigate to the main screen
      Navigator.of(context).pushReplacementNamed('/business-home');
    } else {
      print('Data submission failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _titles[_currentPage],
        showBackButton: true,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 4,
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    color: index <= _currentPage ? Colors.blue : Color(0xFFDEDEDE),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                BusinessCategoryScreen(
                  onCategorySelected: _onCategorySelected,
                  goToNextPage: _goToNextPage,
                ),
                BusinessCompanyLogoScreen(
                  onNext: _goToNextPage,
                  onLogoSelected: _onLogoSelected,
                ),
                BusinessAboutScreen(
                  onNext: _goToNextPage,
                  onDescriptionUpdated: _onDescriptionUpdated,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
