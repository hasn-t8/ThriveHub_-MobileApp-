//import
import 'package:flutter/material.dart';

class TabButtons extends StatelessWidget {
  final bool isAllSelected;
  final VoidCallback onSelectAll;
  final VoidCallback onSelectMyReviews;
  final String allText;
  final String myReviewsText;

  TabButtons({
    required this.isAllSelected,
    required this.onSelectAll,
    required this.onSelectMyReviews,
    this.allText = 'All',
    this.myReviewsText = 'My reviews',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: isAllSelected ? Colors.white : Color(0xFFD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.0),
                    bottomLeft: Radius.circular(6.0),
                  ),
                ),
                side: BorderSide.none, // Remove internal border
              ),
              onPressed: onSelectAll,
              child: Text(
                allText,
                style: TextStyle(
                  color: isAllSelected ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: isAllSelected ? Color(0xFFD9D9D9) : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6.0),
                    bottomRight: Radius.circular(6.0),
                  ),
                ),
                side: BorderSide.none, // Remove internal border
              ),
              onPressed: onSelectMyReviews,
              child: Text(
                myReviewsText,
                style: TextStyle(
                  color: isAllSelected ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
