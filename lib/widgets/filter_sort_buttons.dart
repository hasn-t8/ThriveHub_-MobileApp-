import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thrive_hub/screens/user/search_screens/filter_screen.dart';

class FilterSortButtons extends StatefulWidget {
  final VoidCallback onFilter;

  const FilterSortButtons({
    required this.onFilter,
    Key? key,
  }) : super(key: key);

  @override
  _FilterSortButtonsState createState() => _FilterSortButtonsState();
}

class _FilterSortButtonsState extends State<FilterSortButtons> {
  List<String> selectedFilters = []; // To store selected filter options

  void fetchSortedData(String sortOption) {
    // Implement sorting logic here
  }

  // Navigate to FilterScreen
  void navigateToFilterScreen() async {
    final selectedOptions = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (context) => FilterScreen()),
    );

    if (selectedOptions != null) {
      setState(() {
        selectedFilters = selectedOptions; // Update selected filters
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter and Sort Buttons
        Container(
          width: 343,
          height: 43,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: const Color(0xFFD9D9D9),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              // Filter Button
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  label: const Text('Filter', style: TextStyle(color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide.none,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: navigateToFilterScreen,
                ),
              ),
              // Divider
              Container(
                width: 1,
                color: const Color(0xFFC3C1C1),
              ),
              // Sort Button
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.sort, color: Colors.black),
                  label: const Text('Sort', style: TextStyle(color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide.none,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final selectedOption = await showModalBottomSheet<String>(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (context) => const SortBottomSheet(),
                    );

                    if (selectedOption != null) {
                      fetchSortedData(selectedOption);
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // Display selected filters in a horizontal scrollable list
        if (selectedFilters.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedFilters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0), // Horizontal padding added for space between boxes
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow effect
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Text with custom styling
                        Text(
                          filter,
                          style: TextStyle(
                            fontFamily: 'Inter', // Font family
                            fontSize: 13, // Font size
                            fontWeight: FontWeight.w500, // Font weight
                            height: 25 / 13, // Line height
                            letterSpacing: 0.38, // Letter spacing
                            color: Colors.black, // Text color
                          ),
                        ),
                        const SizedBox(width: 5),
                        // Star icon with color #4D4D4D
                        Icon(
                          Icons.star,
                          color: Color(0xFF4D4D4D), // Star color
                          size: 16, // Size of the star
                        ),
                        const SizedBox(width: 5),
                        // Custom delete icon (close button)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilters.remove(filter);
                            });
                          },
                          child: Container(
                            width: 13.5, // Width of the circle
                            height: 13.5, // Height of the circle
                            padding: const EdgeInsets.all(3), // Padding to ensure icon fits well
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF8E8E93), // Circle color
                            ),
                            child: Center( // Centering the cross icon
                              child: const Icon(
                                Icons.close,
                                color: Colors.white, // Cross icon color
                                size: 7, // Adjusted size for the cross icon to fit within the circle
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),


      ],
    );
  }
}




Future<void> fetchSortedData(String sortOption) async {
    final response = await http.get(
      Uri.parse('https://api.example.com/data?sort=$sortOption'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Sorted Data: $data');
    } else {
      print('Failed to fetch sorted data');
    }
  }



class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({Key? key}) : super(key: key);

  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  String selectedOption = '';

  final TextStyle title3Regular = const TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 25 / 20, // Line height ratio
    letterSpacing: 0.38,
    color: Color(0xFF201C41), // Updated text color
    decoration: TextDecoration.none,
  );

  final TextStyle sortTitleStyle = const TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 20 / 17, // Line height ratio
    letterSpacing: -0.5,
    color: Colors.black, // Sort title color
    textBaseline: TextBaseline.alphabetic,
    decoration: TextDecoration.none,
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: const Color(0xFFD9D9D9),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sort',
                      style: sortTitleStyle, // Updated style
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 14.0), // Adjust the right margin as needed
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8E8E93), // Background color
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 15, // Adjust the size of the icon to fit within 17x17
                        color: Colors.white, // Icon color
                      ),
                      padding: EdgeInsets.zero, // Remove extra padding
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFD9D9D9), thickness: 1),

              // Price Low to High Section
              buildOptionRow('Price Low to High'),
              const Divider(color: Color(0xFFD9D9D9), thickness: 1),

              // Price High to Low Section
              buildOptionRow('Price High to Low'),
              const Divider(color: Color(0xFFD9D9D9), thickness: 1),

              // Rating Section
              buildOptionRow('Rating'),
              const Divider(color: Color(0xFFD9D9D9), thickness: 1),

              // Newest Section
              buildOptionRow('Newest'),
              const Divider(color: Color(0xFFD9D9D9), thickness: 1),

              const SizedBox(height: 6),

              // Apply Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(343, 54),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, selectedOption);
                },
                child: const Text(
                  'Show',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionRow(String text) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedOption = text;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: title3Regular),
          Radio<String>(
            value: text,
            groupValue: selectedOption,
            activeColor: Colors.black,
            fillColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.black; // Selected color
                }
                return const Color(0xFFD9D9D9); // Unselected color
              },
            ),
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
        ],
      ),
    );
  }

}

