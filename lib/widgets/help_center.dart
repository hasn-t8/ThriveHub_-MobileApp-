import 'package:flutter/material.dart';

class HelpCenterItem extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const HelpCenterItem({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
  }) : super(key: key);

  @override
  _HelpCenterItemState createState() => _HelpCenterItemState();
}

class _HelpCenterItemState extends State<HelpCenterItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(widget.icon, size: 24, color: Colors.grey),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.description,
                        maxLines: _isExpanded ? null : 2, // Show full text when expanded
                        overflow: _isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis, // Ellipsis when collapsed
                        style: const TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 12, // Equivalent to the 12px font-size
                          fontWeight: FontWeight.w400, // Regular weight
                          fontFamily: 'Inter', // Set the font to 'Inter'
                          height: 1.08, // Line height (12px font size * 1.08 = ~13px)
                          letterSpacing: 0.07, // Letter spacing (0.07000000029802322px)
                          decoration: TextDecoration.none, // No text decoration
                          decorationThickness: 1.0, // Text decoration skip
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.expand_more : Icons.chevron_right,
                  size: 24, // Increased size for bold appearance
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 1.0, // Adds a bold effect
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFC7C7CC),
          thickness: 1,
          height: 1,
        ),
      ],
    );
  }
}
