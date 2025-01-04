import 'package:flutter/material.dart';
import '../../../core/constants/text_styles.dart';

class BusinessCategoryScreen extends StatefulWidget {
  final Function(String) onCategorySelected;
  final VoidCallback goToNextPage;

  BusinessCategoryScreen({required this.onCategorySelected, required this.goToNextPage});

  @override
  _BusinessCategoryScreenState createState() => _BusinessCategoryScreenState();
}

class _BusinessCategoryScreenState extends State<BusinessCategoryScreen> {
  String _selectedCategory = '';

  Widget _buildCategoryBox(String category, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          widget.onCategorySelected(category);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedCategory == category ? Color(0xFF828282) : Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedCategory == category ? Color(0xFF828282) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Center the Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 50, // Adjust width as per your requirement
                height: 50, // Adjust height as per your requirement
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 8),
            // Text below the image
            Text(
              category,
              style: TextStyle(
                color: Colors.black, // Adjust color if needed
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 20 / 15,
                letterSpacing: -0.24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              'Nice to see you here, Company Name',
              style: bSubheadingTextStyle,
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet consectetur. Quisque aenean eu nunc tempor iaculis. Ut lorem est vitae amet urna enim turpis varius tellus.',
              style: bDescriptionTextStyle,
            ),
            SizedBox(height: 24),
            Text(
              'Choose your Category',
              style: bHeadingTextStyle,
            ),
            SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: MediaQuery.of(context).size.width / 2 / 117,
              children: [
                _buildCategoryBox('Tech', 'assets/tech.png'),
                _buildCategoryBox('Wellness', 'assets/wellness.png'),
                _buildCategoryBox('Finance', 'assets/finance.png'),
                _buildCategoryBox('Home Electronic', 'assets/electronics.png'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedCategory.isNotEmpty
                ? widget.goToNextPage
                : null, // Only enable button if a category is selected
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedCategory.isNotEmpty
                  ? Color(0xFF828282)
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(double.infinity, 56),
            ),
            child: Text(
              'Continue',
              style: kButtonTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
