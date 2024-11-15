// custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final bool showConfirmationButtons; // Whether to show Yes/No buttons
  final VoidCallback? onYesPressed; // Callback for Yes button press
  final VoidCallback? onNoPressed; // Callback for No button press

  CustomAppBar({
    required this.title,
    this.showBackButton = false,
    this.centerTitle = false,
    this.onBackPressed,
    this.showConfirmationButtons = false,
    this.onYesPressed,
    this.onNoPressed,
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
          style: TextStyle(color: Colors.black),
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
        actions: showConfirmationButtons
            ? [
          TextButton(
            onPressed: onYesPressed,
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.green),
            ),
          ),

          
          TextButton(
            onPressed: onNoPressed,
            child: Text(
              'No',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ]
            : [],
      ),
    );

  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 2.0);
}
