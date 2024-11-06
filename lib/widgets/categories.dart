import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  final int selectedBoxIndex;
  final Function(int) onBoxSelected;
  final List<Map<String, String>> categories; // Accepts a list of maps for categories

  CategoriesWidget({
    required this.selectedBoxIndex,
    required this.onBoxSelected,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 380,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: categories.length, // Use the length of categories
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 168 / 188,
        ),
        itemBuilder: (context, index) {
          final category = categories[index]; // Get the current category map
          return GestureDetector(
            onTap: () => onBoxSelected(index),
            child: Container(
              decoration: BoxDecoration(
                color: selectedBoxIndex == index ? Color(0xFFBFBFBF) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['title'] ?? '', // Display dynamic title
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      category['description'] ?? '', // Display dynamic description
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
