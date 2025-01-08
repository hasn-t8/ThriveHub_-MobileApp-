import 'package:flutter/material.dart';

class FilterSortButtons extends StatefulWidget {
  final Future<List<String>> Function(BuildContext context) onFilter;
  final Future<String?> Function(BuildContext context) onSort;
  final Function(List<String>) onFiltersUpdated; // Callback to notify parent about filters

  const FilterSortButtons({
    required this.onFilter,
    required this.onSort,
    required this.onFiltersUpdated,
    Key? key,
  }) : super(key: key);

  @override
  _FilterSortButtonsState createState() => _FilterSortButtonsState();
}

class _FilterSortButtonsState extends State<FilterSortButtons> {
  List<String> selectedFilters = [];
  String? selectedSortOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter and Sort Buttons
        Container(
          width: 343,
          height: 43,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: const Color(0xFFD9D9D9),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              // Filter Button
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  label: const Text('Filter', style: TextStyle(color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide.none,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final filters = await widget.onFilter(context);
                    if (filters.isNotEmpty) {
                      setState(() {
                        selectedFilters = filters;
                      });
                      _applyUpdatedFilters(); // Apply the updated filters
                    }
                  },
                ),
              ),
              // Divider
              Container(
                width: 1,
                color: const Color(0xFFC3C1C1),
              ),
              // Sort Button
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.sort, color: Colors.black),
                  label: const Text('Sort', style: TextStyle(color: Colors.black)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide.none,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    final sortOption = await widget.onSort(context);
                    if (sortOption != null) {
                      setState(() {
                        selectedSortOption = sortOption;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // Display selected filters in a horizontal scrollable list
        if (selectedFilters.isNotEmpty || selectedSortOption != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Display Filters
                  ...selectedFilters.map((filter) {
                    return _buildChip(
                      label: filter,
                      onRemove: () {
                        setState(() {
                          selectedFilters.remove(filter); // Remove the filter
                        });
                        _applyUpdatedFilters(); // Reapply filters
                      },
                    );
                  }),
                  // Display Selected Sort Option
                  if (selectedSortOption != null)
                    _buildChip(
                      label: "Sort: $selectedSortOption",
                      onRemove: () {
                        setState(() {
                          selectedSortOption = null;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Build individual chip for filters or sort option
  Widget _buildChip({required String label, required VoidCallback onRemove}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 13.5,
                height: 13.5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF8E8E93),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Apply updated filters to the list
  void _applyUpdatedFilters() {
    // Notify the parent widget about the updated filters
    widget.onFiltersUpdated(selectedFilters);
  }
}
