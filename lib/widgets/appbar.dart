import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton; // Whether to show the back button
  final bool centerTitle; // Whether to center align the title
  final VoidCallback? onBackPressed; // Callback for back button press

  CustomAppBar({
    required this.title,
    this.showBackButton = false,
    this.centerTitle = false, // Defaults to left-align title
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDADADA),
            width: 2.0, // Adjust the width as needed
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: centerTitle,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          color: Colors.black,
        )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 2.0); // Adjust height to include the bottom border
}
