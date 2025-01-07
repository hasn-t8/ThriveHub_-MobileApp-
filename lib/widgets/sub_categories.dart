import 'package:flutter/material.dart';

class SubcategoriesWidget extends StatefulWidget {
  final String categoryTitle;
  final List<Map<String, String>> items; // Each item contains 'name' and 'logoUrl'
  final VoidCallback? onSeeAllTap;
  final Color containerColor;
  final Color dropBoxColor;
  final ValueChanged<int>? onItemTap; // Callback for item selection with index

  const SubcategoriesWidget({
    Key? key,
    required this.categoryTitle,
    required this.items,
    this.onSeeAllTap,
    this.containerColor = Colors.white,
    this.dropBoxColor = const Color(0xFFE9E8E8),
    this.onItemTap, // Optional callback
  }) : super(key: key);

  @override
  _SubcategoriesWidgetState createState() => _SubcategoriesWidgetState();
}

class _SubcategoriesWidgetState extends State<SubcategoriesWidget> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 394,
      height: 193,
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: widget.containerColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            offset: const Offset(0, 1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.categoryTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 20 / 20,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onSeeAllTap,
                  child: Row(
                    children: [
                      const Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w500,
                          height: 20 / 14,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.items.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Map<String, String> item = entry.value;
                  final String name = item['name'] ?? "Unknown";
                  final String logoUrl = item['logoUrl'] ?? "";

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      if (widget.onItemTap != null) {
                        widget.onItemTap!(index); // Invoke the callback with the index
                      }
                    },
                    child: Container(
                      width: 131,
                      height: 117,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? const Color(0xFFBFBFBF)
                            : widget.dropBoxColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display logo
                          Expanded(
                            child: logoUrl.isNotEmpty
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                logoUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 40, color: Colors.grey),
                              ),
                            )
                                : const Icon(
                              Icons.business,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Display name
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                              height: 22 / 14,
                              letterSpacing: -0.24,
                              color: selectedIndex == index
                                  ? Colors.white
                                  : const Color(0xFF414141),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
