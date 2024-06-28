import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Search',showBackButton: false, centerTitle: true),
      body: Center(child: Text('Search Screen')),
    );
  }
}
