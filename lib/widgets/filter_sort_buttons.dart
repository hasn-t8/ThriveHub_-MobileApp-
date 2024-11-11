import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thrive_hub/user_screens/search_screens/filter_screen.dart';

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
  List<int> selectedCategories = [];
  List<int> selectedRatings = [];

  void fetchSortedData(String sortOption) {
    // Implement sorting logic here.
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
                  onPressed: () async {
                    final result = await Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterScreen(
                          selectedCategories: selectedCategories,
                          selectedRatings: selectedRatings.toSet(), // Convert List to Set
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        selectedCategories = result['categories'] ?? [];
                        selectedRatings = (result['ratings'] ?? <int>{}).toList(); // Convert Set back to List
                      });
                    }
                  },

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

        // Selected Chips Section
        // const SizedBox(height: 2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Selected Categories
              ...selectedCategories.map(
                    (category) => Padding(
                  padding: const EdgeInsets.all(6.0), // Outer padding
                  child: Container(
                    height: 40.0, // Fixed height
                    padding: const EdgeInsets.symmetric(horizontal: 12.0), // Inner padding
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFD9D9D9), // Shadow color
                          blurRadius: 4.0, // Softness of the shadow
                          offset: Offset(0, 2), // Position of the shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Category ${category + 1}', style: TextStyle(color: Colors.black)),
                        const SizedBox(width: 8),
                        Icon(Icons.star, color: Color(0xFF4D4D4D), size: 18),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategories.remove(category);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF8E8E93),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(Icons.close, color: Colors.white, size: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Selected Ratings
              ...selectedRatings.map(
                    (rating) => Padding(
                  padding: const EdgeInsets.all(6.0), // Outer padding
                  child: Container(
                    height: 40.0, // Fixed height
                    padding: const EdgeInsets.symmetric(horizontal: 12.0), // Inner padding
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFD9D9D9), // Shadow color
                          blurRadius: 4.0, // Softness of the shadow
                          offset: Offset(0, 2), // Position of the shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$rating Star', style: TextStyle(color: Colors.black)),
                        const SizedBox(width: 8),
                        Icon(Icons.star, color: Color(0xFF4D4D4D), size: 18),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRatings.remove(rating);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF8E8E93),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(Icons.close, color: Colors.white, size: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
                  const Expanded(
                    child: Text(
                      'Sort',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.5,
                        textBaseline: TextBaseline.alphabetic,
                      ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Price Low to High'),
                  Radio<String>(
                    value: 'Price Low to High',
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
              const Divider(color: Color(0xFFD9D9D9), thickness: 1),

              // Price High to Low Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Price High to Low'),
                  Radio<String>(
                    value: 'Price High to Low',
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
              const Divider(color: Color(0xFFD9D9D9), thickness: 1),

              // Rating Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Rating'),
                  Radio<String>(
                    value: 'Rating',
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
              const Divider(color: Color(0xFFD9D9D9), thickness: 1),

              // Newest Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Newest'),
                  Radio<String>(
                    value: 'Newest',
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
}
