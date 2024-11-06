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
      height: 380,
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
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFBFBFBF) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F000000), // Equivalent to #0000001F
                    offset: Offset(0, 1),
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['title'] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      category['description'] ?? '',
                      style: TextStyle(

                        fontSize: 10,
                        color: isSelected ? Colors.white : Colors.grey,
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
