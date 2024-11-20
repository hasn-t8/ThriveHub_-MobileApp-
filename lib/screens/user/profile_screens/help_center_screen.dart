import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/help_center.dart';

class HelpCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Help Center',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Container(
        // Get screen width and height using MediaQuery
        width: MediaQuery.of(context).size.width, // Full screen width
        height: MediaQuery.of(context).size.height, // Full screen height
        color: Colors.white, // Screen color set to FFFFFF
        child: SingleChildScrollView(
          // Allows the content to scroll if it overflows the screen
          child: Padding(
            padding: const EdgeInsets.all(20), // Adds consistent padding for all sides
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.11), // 0x0000001C as opacity
                    offset: Offset(0, 4),
                    blurRadius: 33,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Adds inner padding for content
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Adjusts height dynamically based on content
                  children: [
                    HelpCenterItem(
                      title: "FAQ",
                      description: "One answer is that Truth pertains to the possibility that an event will occur. This answer is an example to illustrate.",
                      icon: Icons.help_outline,
                    ),
                    HelpCenterItem(
                      title: "Chat",
                      description: "One answer is that Truth pertains to the possibility that an event will occur. This answer is an example to illustrate.",
                      icon: Icons.chat_bubble_outline,
                    ),
                    HelpCenterItem(
                      title: "Call Support",
                      description: "One answer is that Truth pertains to the possibility that an event will occur. This answer is an example to illustrate.",
                      icon: Icons.call,
                    ),
                    HelpCenterItem(
                      title: "Community",
                      description: "One answer is that Truth pertains to the possibility that an event will occur. This answer is an example to illustrate.",
                      icon: Icons.people_outline,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
