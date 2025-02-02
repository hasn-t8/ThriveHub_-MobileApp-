import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final bool showConfirmationButtons; // Whether to show Yes/No buttons
  final VoidCallback? onYesPressed; // Callback for Yes button press
  final VoidCallback? onNoPressed; // Callback for No button press
  final bool showAddIcon; // Whether to show the + icon
  final VoidCallback? onAddPressed; // Callback for the + icon press

  CustomAppBar({
    required this.title,
    this.showBackButton = false,
    this.centerTitle = false,
    this.onBackPressed,
    this.showConfirmationButtons = false,
    this.onYesPressed,
    this.onNoPressed,
    this.showAddIcon = false, // Default to not showing the add icon
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDADADA),
            width: 2.0,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Color(0xFFFCFCFC),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: 'Inter', // Set the font family to 'Inter'
            fontWeight: FontWeight.w600, // Set font weight to 600
          ),
        ),
        centerTitle: centerTitle,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          color: Colors.black,
        )
            : null,
        actions: [
          if (showConfirmationButtons)
            TextButton(
              onPressed: onYesPressed,
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.green),
              ),
            ),
          if (showConfirmationButtons)
            TextButton(
              onPressed: onNoPressed,
              child: Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
            ),
          if (showAddIcon && onAddPressed != null) // Conditionally show the + icon
            IconButton(
              icon: Icon(
                Icons.add,
                size: 28, // Size of the + icon
                color: Colors.black,
              ),
              onPressed: onAddPressed,
            ),
          SizedBox(width: 8), // You can adjust the width as needed
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 2.0);
}
