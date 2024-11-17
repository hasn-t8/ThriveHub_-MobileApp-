import 'package:flutter/material.dart';
import '../../core/constants/text_styles.dart';

class CustomHeaderTh extends StatelessWidget {
  final String headingText;
  final String headingImagePath;
  final String subheadingText;
  final Color backgroundColor;
  final double topPadding;
  final double bottomPadding;

  const CustomHeaderTh({
    Key? key,
    required this.headingText,
    this.headingImagePath = '',
    this.subheadingText = '',
    this.backgroundColor = kDividerColor, // Default value
    this.topPadding = 80.0,
    this.bottomPadding = 6.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: double.infinity,
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(headingText, style: kHeadingTextStyle),
                const SizedBox(width: 10),
                headingImagePath.isNotEmpty ? Image.asset(headingImagePath, width: 49, height: 49) : const SizedBox(),
              ],
            ),
            if (subheadingText.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                subheadingText,
                style: kSubheadingTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
