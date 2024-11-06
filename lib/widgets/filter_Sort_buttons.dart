import 'package:flutter/material.dart';

class FilterSortButtons extends StatelessWidget {
  final VoidCallback onFilter;
  final VoidCallback onSort;

  FilterSortButtons({
    required this.onFilter,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 160, // Increased width
            child: OutlinedButton.icon(
              icon: Icon(Icons.filter_list, color: Colors.black),
              label: Text('Filter', style: TextStyle(color: Colors.black)),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Color(0xFFC3C1C1)), // Border color for Filter button
                ),
              ),
              onPressed: onFilter,
            ),
          ),
          SizedBox(width: 10), // Space between the buttons
          SizedBox(
            width: 160, // Increased width
            child: OutlinedButton.icon(
              icon: Icon(Icons.sort, color: Colors.black),
              label: Text('Sort', style: TextStyle(color: Colors.black)),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: BorderSide(color: Color(0xFFC3C1C1)), // Border color for Sort button
                ),
              ),
              onPressed: onSort,
            ),
          ),
        ],
      ),
    );
  }
}
