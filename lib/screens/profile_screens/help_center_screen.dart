import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';

class HelpCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Help Center',showBackButton: true, centerTitle: true),

      body: Center(
        child: Text(
          'Help Center Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
