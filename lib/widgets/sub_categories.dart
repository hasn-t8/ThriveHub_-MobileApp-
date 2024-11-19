import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/user/search_screens/services_screen.dart';

class SubcategoriesWidget extends StatefulWidget {
  final String categoryTitle; // Title of the category
  final List<String> items; // List of items to display in boxes
  final VoidCallback? onSeeAllTap; // Optional callback for the "See All" button
  final Color containerColor; // Background color of the main container
  final Color dropBoxColor; // Background color of the drop boxes

  const SubcategoriesWidget({
    Key? key,
    required this.categoryTitle,
    required this.items,
    this.onSeeAllTap,
    this.containerColor = Colors.white, // Default color for the main container
    this.dropBoxColor = const Color(0xFFE9E8E8), // Default color for drop boxes
  }) : super(key: key);

  @override
  _SubcategoriesWidgetState createState() => _SubcategoriesWidgetState();
}

class _SubcategoriesWidgetState extends State<SubcategoriesWidget> {
  int? selectedIndex; // Tracks the selected index, ensures only one selection

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 394,
      height: 193,
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: widget.containerColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000), // Lighter shadow color with lower opacity
            offset: const Offset(0, 1),
            blurRadius: 8, // Slightly reduced blur radius for a softer shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row for the title and "See All" button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
              children: [
                Expanded(
                  child: Text(
                    widget.categoryTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter', // Set the font family
                      fontWeight: FontWeight.w700, // Medium weight
                      height: 20/20,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 2, // Allows the title to break onto a second line if needed
                    overflow: TextOverflow.ellipsis, // Adds ellipsis if text is too long
                  ),
                ),
                GestureDetector(
                  onTap: widget.onSeeAllTap,
                  child: Row(
                    children: [
                      Text(
                        'See All',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'SF Pro Display', // Set the font family
                          fontWeight: FontWeight.w500, // Medium weight
                          height: 20/14,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Horizontal scrollable row of boxes, aligned to start
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.items.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final String item = entry.value;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index; // Set the selected box
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServicesScreen(),
                        ),
                      );
                      print('Clicked on $item');
                    },
                    child: Container(
                      width: 131,
                      height: 117,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? const Color(0xFFBFBFBF) // Selected background color
                            : widget.dropBoxColor, // Default background color
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                            height: 22/14,
                            letterSpacing: -0.24,
                            color: selectedIndex == index
                                ? Colors.white // Selected text color
                                : Color(0xFF414141), // Default text color
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}