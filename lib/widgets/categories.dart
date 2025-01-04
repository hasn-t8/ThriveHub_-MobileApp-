import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  final int selectedBoxIndex;
  final Function(int) onBoxSelected;
  final List<Map<String, String>> categories;

  CategoriesWidget({
    required this.selectedBoxIndex,
    required this.onBoxSelected,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 460,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 168 / 188,
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedBoxIndex == index;
          return GestureDetector(
            onTap: () => onBoxSelected(index),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFBFBFBF) : Colors.white, // Dynamic color
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F000000),
                    offset: Offset(0, 1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Rounded corners for the image
                child: Column(
                  children: [
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    // Image at the top center
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset(
                        category['image'] ?? '',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Spacer(),
                    // Text content at the bottom
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category['title'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              fontSize: 13,
                              height: 20 / 15,
                              letterSpacing: -0.24,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            category['description'] ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 12.5 / 10,
                              letterSpacing: -0.24,
                              color: isSelected ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
