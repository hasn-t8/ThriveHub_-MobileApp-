import 'package:flutter/material.dart';

class SelectableScrollableRow extends StatefulWidget {
  final String title; // Title parameter
  final List<String> options;
  final Set<String> selectedOptions;
  final Function(Set<String>) onSelectionChanged;
  final bool showStarIcon; // Optional parameter to show/hide the star

  const SelectableScrollableRow({
    required this.title, // Required title parameter
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
    this.showStarIcon = true, // Default is true, but can be set to false
  });

  @override
  _SelectableScrollableRowState createState() => _SelectableScrollableRowState();
}

class _SelectableScrollableRowState extends State<SelectableScrollableRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            widget.title, // Use the title passed in the constructor
            style: const TextStyle(
              fontFamily: 'SF Pro Display', // Your preferred font
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 45, // Height of the scrollable row
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.options.length,
            itemBuilder: (context, index) {
              final option = widget.options[index];
              bool isSelected = widget.selectedOptions.contains(option);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      widget.selectedOptions.remove(option);
                    } else {
                      widget.selectedOptions.add(option);
                    }
                  });
                  widget.onSelectionChanged(widget.selectedOptions);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12.0), // Gap between the boxes
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Padding inside the box
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6C6C6C) : Colors.white,
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: const [
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
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      widget.showStarIcon // Check if star should be shown
                          ? const SizedBox(width: 4)
                          : const SizedBox.shrink(), // Only add space if the star is shown
                      widget.showStarIcon // If true, show the star icon
                          ? Icon(
                        Icons.star,
                        color: isSelected ? Colors.white : const Color(0xFF4D4D4D),
                        size: 17,
                      )
                          : const SizedBox.shrink(), // No space or icon if false
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
