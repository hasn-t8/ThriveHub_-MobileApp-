import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String? heading;
  final bool showHeading;
  final bool showSearchBar;
  final bool showLine;

  HeaderWidget({
    this.heading,
    this.showHeading = true,
    this.showSearchBar = true,
    this.showLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeading && heading != null)
            Text(
              heading!,
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.23,
                letterSpacing: 0.374,
                color: Colors.black,
              ),
            ),
          if (showHeading) SizedBox(height: 11),
          if (showSearchBar)
            Container(
              height: 36,
              width: double.infinity,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFE9E9EA),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Color(0xFFBFBFBF)),
                  prefixIcon: Icon(Icons.search, color: Color(0xFFBFBFBF)),
                  suffixIcon: Icon(Icons.mic, color: Color(0xFFBFBFBF)),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          if (showSearchBar) SizedBox(height: 9),
          if (showLine)
            Container(
              height: 1,
              color: Color(0xFFE9E9EA),
            ),
        ],
      ),
    );
  }
}
