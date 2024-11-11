import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final Set<int> selectedRatings;
  final Function(Set<int>) onRatingChanged;

  const RatingWidget({
    Key? key,
    required this.selectedRatings,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  late Set<int> selectedRatings;

  @override
  void initState() {
    super.initState();
    selectedRatings = Set.from(widget.selectedRatings);
  }

  void _toggleRating(int rating) {
    setState(() {
      if (selectedRatings.contains(rating)) {
        selectedRatings.remove(rating);
      } else {
        selectedRatings.add(rating);
      }
      widget.onRatingChanged(selectedRatings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Rating',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: List.generate(
              5,
                  (index) {
                final isSelected = selectedRatings.contains(index + 1);
                return GestureDetector(
                  onTap: () => _toggleRating(index + 1),
                  child: Container(
                    margin: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6C6C6C)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1} Star',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.star,
                          color: isSelected ? Colors.white : const Color(0xFF4D4D4D),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
