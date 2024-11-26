import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchSortedData(String sortOption) async {
  final response = await http.get(
    Uri.parse('https://api.example.com/data?sort=$sortOption'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Sorted Data: $data');
  } else {
    print('Failed to fetch sorted data');
  }
}

class SortBottomSheet extends StatefulWidget {
  final String title;
  final List<String> sortOptions;

  const SortBottomSheet({
    Key? key,
    required this.title,
    required this.sortOptions,
  }) : super(key: key);

  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  String selectedOption = '';

  final TextStyle title3Regular = const TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 25 / 20,
    letterSpacing: 0.38,
    color: Color(0xFF201C41),
    decoration: TextDecoration.none,
  );

  final TextStyle sortTitleStyle = const TextStyle(
    fontFamily: 'SF Pro Display',
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 20 / 17,
    letterSpacing: -0.5,
    color: Colors.black,
    textBaseline: TextBaseline.alphabetic,
    decoration: TextDecoration.none,
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: const Color(0xFFD9D9D9),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: sortTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 14.0),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8E8E93),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFD9D9D9), thickness: 1),

              // Sort Options
              ...widget.sortOptions
                  .map((option) => Column(
                children: [
                  buildOptionRow(option),
                  const Divider(color: Color(0xFFD9D9D9), thickness: 1),
                ],
              ))
                  .toList(),

              const SizedBox(height: 6),

              // Apply Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(343, 54),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, selectedOption);
                },
                child: const Text(
                  'Show',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionRow(String text) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedOption = text;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: title3Regular),
          Radio<String>(
            value: text,
            groupValue: selectedOption,
            activeColor: Colors.black,
            fillColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.black;
                }
                return const Color(0xFFD9D9D9);
              },
            ),
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}
