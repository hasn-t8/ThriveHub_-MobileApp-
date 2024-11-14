import 'package:flutter/material.dart';

class ServiceTabs extends StatefulWidget {
  final String firstTabText;
  final String secondTabText;
  final Function(bool isFirstTab) onTabSelected;

  const ServiceTabs({
    Key? key,
    required this.firstTabText,
    required this.secondTabText,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  State<ServiceTabs> createState() => _ServiceTabsState();
}

class _ServiceTabsState extends State<ServiceTabs> {
  bool isFirstSelected = true;

  @override
  Widget build(BuildContext context) {
    final double containerWidth = 323.0;
    final double tabWidth = containerWidth / 2;

    return Container(
      width: containerWidth,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // First Tab
          GestureDetector(
            onTap: () {
              setState(() {
                isFirstSelected = true;
              });
              widget.onTabSelected(true); // Notify parent about tab selection
            },
            child: Container(
              width: tabWidth,
              height: 32,
              decoration: BoxDecoration(
                color: isFirstSelected ? Colors.white : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                border: isFirstSelected
                    ? Border.all(
                  color: const Color(0x1A000000),
                  width: 0.5,
                )
                    : null,
                boxShadow: isFirstSelected
                    ? [
                  const BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 3),
                    blurRadius: 1,
                  ),
                  const BoxShadow(
                    color: Color(0x1F000000),
                    offset: Offset(0, 3),
                    blurRadius: 8,
                  ),
                ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                widget.firstTabText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: isFirstSelected ? Colors.black : Colors.grey[700],
                ),
              ),
            ),
          ),

          // Second Tab
          GestureDetector(
            onTap: () {
              setState(() {
                isFirstSelected = false;
              });
              widget.onTabSelected(false); // Notify parent about tab selection
            },
            child: Container(
              width: tabWidth,
              height: 32,
              decoration: BoxDecoration(
                color: !isFirstSelected ? Colors.white : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                border: !isFirstSelected
                    ? Border.all(
                  color: const Color(0x1A000000),
                  width: 0.5,
                )
                    : null,
                boxShadow: !isFirstSelected
                    ? [
                  const BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 3),
                    blurRadius: 1,
                  ),
                  const BoxShadow(
                    color: Color(0x1F000000),
                    offset: Offset(0, 3),
                    blurRadius: 8,
                  ),
                ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                widget.secondTabText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: !isFirstSelected ? Colors.black : Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
