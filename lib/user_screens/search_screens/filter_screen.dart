import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/rating_widget.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> filterOptions = [
    'Web Hosting Services',
    'VPN Providers',
    'Cloud Storage Providers',
    'Ecommerce Platforms',
    'Security Software Companies',
    'CRM Software',
    'Accounting Software',
    'Email Marketing Tools',
    'Video Editing Software',
    'Education & Productivity',
    'Project Management Tools',
    'Customer Service Software ',
    'Graphic Design Software',
    'Marketing Automation Software',
  ];

  Set<String> selectedFilters = Set();
  Set<String> additionalFilters = Set(); // For the new scrollable row filters
  Set<String> additionalFilters2 = Set(); // For the new scrollable row filters

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add SelectableScrollableRow here
            SelectableScrollableRow(
              title: 'Rating', // Pass the title here
              options: ['All', '4+', '4','3','2'], // Add your list
              selectedOptions: additionalFilters,
              onSelectionChanged: (newSelection) {
                setState(() {
                  additionalFilters = newSelection;
                });
              },
            ),
            const SizedBox(height: 10),
            // Categories section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Category',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      // Add space at the top before the list
                      SizedBox(height: 8), // Adjust the height as needed
                      // The list of filter options in a Wrap widget
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: filterOptions.map((option) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedFilters.contains(option)) {
                                  selectedFilters.remove(option);
                                } else {
                                  selectedFilters.add(option);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                color: selectedFilters.contains(option)
                                    ? Color(0xFF6C6C6C)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x1F000000),
                                    offset: Offset(0, 1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    option,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: selectedFilters.contains(option)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  // Show star when selected
                                  if (selectedFilters.contains(option))
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.white, // Star color when selected
                                        size: 17, // Adjust the size as needed
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            // Add SelectableScrollableRow here
            SelectableScrollableRow(
              title: 'Special needs', // Pass the title here
              options: ['Free services', 'Only with reviews',], // Add your list
              selectedOptions: additionalFilters2,
              showStarIcon: false, // Set to false if you don't want the star icon
              onSelectionChanged: (newSelection) {
                setState(() {
                  additionalFilters2 = newSelection;
                });

              },
            ),
            // Show Results Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  fixedSize: const Size(343, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                onPressed: () {
                  // Passing the selected filters to the previous screen
                  Navigator.pop(context, {...selectedFilters, ...additionalFilters,...additionalFilters2}.toList());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Show Results',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (selectedFilters.isNotEmpty || additionalFilters.isNotEmpty ||additionalFilters2.isNotEmpty)
                      Text(
                        '(${selectedFilters.length + additionalFilters.length + additionalFilters2.length})',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
