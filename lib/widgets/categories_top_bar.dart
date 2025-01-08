import 'package:flutter/material.dart';

class CategoriesTopBar extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategorySelected; // Callback for selected category
  final String? initialSelectedCategory; // Optional initial selected category

  const CategoriesTopBar({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
    this.initialSelectedCategory,
  }) : super(key: key);

  @override
  _CategoriesTopBarState createState() => _CategoriesTopBarState();
}

class _CategoriesTopBarState extends State<CategoriesTopBar> {
  int? _selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    // Set initial selected category if provided
    if (widget.initialSelectedCategory != null) {
      _selectedCategoryIndex =
          widget.categories.indexOf(widget.initialSelectedCategory!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          // Top Line
          Container(
            height: 1,
            color: const Color(0xFFE9E9EA),
          ),
          const SizedBox(height: 10),

          // Horizontal Scrollable Area with Left Padding
          Padding(
            padding: const EdgeInsets.only(left: 8.0), // Left padding for the row
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.categories.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;

                  final bool isSelected = index == _selectedCategoryIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index; // Update selected index
                      });
                      // Notify parent widget about the selected category
                      widget.onCategorySelected(category);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFBFBFBF)
                              : Colors.white, // Background color
                          borderRadius: BorderRadius.circular(40),
                          border: isSelected
                              ? null // No border for selected category
                              : Border.all(
                            color: const Color(0xFF79747E), // Border color
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            textAlign: TextAlign.center, // Center-align text
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF79747E),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SF Pro Display',
                              height: 18 / 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Bottom Line
          Container(
            height: 1,
            color: const Color(0xFFE9E9EA),
          ),
        ],
      ),
    );
  }
}
