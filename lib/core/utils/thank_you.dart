import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/alert_box.dart'; // Ensure this imports your CustomAlertBox

/// A utility class to show the "No Page Found" alert.
class ThankYou {
  /// Function to display the "No Page Found" alert.
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertBox(
          title: "Thank You",
          message: "Your description will appear on the page in the near future!",
          imagePath: "assets/no_review.png", // Ensure the asset exists
        );
      },
    );
  }
}
