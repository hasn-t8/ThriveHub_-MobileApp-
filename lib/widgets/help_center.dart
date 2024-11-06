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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: const BoxDecoration(), // Ensures no border or background color
            child: ExpansionTile(
              onExpansionChanged: (expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              leading: Icon(widget.icon, size: 24, color: Colors.grey),
              title: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 20,
                color: Colors.black,
              ),
              subtitle: !_isExpanded
                  ? Text(
                widget.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
                  : null,
              children: [
                if (_isExpanded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.white,
          thickness: 0,
          height: 1,
        ),
      ],
    );
  }
}
