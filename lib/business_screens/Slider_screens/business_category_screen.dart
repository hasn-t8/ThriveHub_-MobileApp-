import 'package:flutter/material.dart';

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
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                imagePath,
                width: 30,
                height: 30,
              ),
            ),
            SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(
                color: _selectedCategory == category ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lorem ipsum dolor sit amet consectetur. Quisque aenean eu nunc tempor iaculis. Ut lorem est vitae amet urna enim turpis varius tellus.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Choose your Category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: MediaQuery.of(context).size.width / 2 / 117,
              children: [
                _buildCategoryBox('Tech', 'assets/category.png'),
                _buildCategoryBox('Wellness', 'assets/category.png'),
                _buildCategoryBox('Finance', 'assets/category.png'),
                _buildCategoryBox('Home Electronic', 'assets/category.png'),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
