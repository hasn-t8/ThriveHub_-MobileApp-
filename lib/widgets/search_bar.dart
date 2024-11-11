import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback onBackButtonPressed;
  final Function(String) onSearchChanged;

  const CustomSearchBar({
    Key? key,
    required this.onBackButtonPressed,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        IconButton(
          onPressed: onBackButtonPressed,
          icon: const Icon(Icons.arrow_back_ios),
        ),

        // Search Bar
        Expanded(
          child: Container(
            width: 343,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE9E9EA), // Background with opacity
              borderRadius: BorderRadius.circular(10), // Rounded top-left corner
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
