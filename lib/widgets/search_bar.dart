import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback onBackButtonPressed;
  final Function(String) onSearchChanged;
  final bool showSearchBar;

  const CustomSearchBar({
    Key? key,
    required this.onBackButtonPressed,
    required this.onSearchChanged,
    this.showSearchBar = true, // Default to showing the search bar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        if (Navigator.canPop(context))
          IconButton(
            onPressed: onBackButtonPressed,
            icon: const Icon(Icons.arrow_back_ios),
          ),

        // Search Bar
        if (showSearchBar)
          Expanded(
            child: Container(
              width: 543,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE9E9EA), // Background with opacity
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.search, color: Colors.black45),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: onSearchChanged,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 7, horizontal: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
