import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/help_center.dart';


class BusinessHelpCenterScreen extends StatelessWidget {
  const BusinessHelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Help Center',
        showBackButton: true,
        centerTitle: true,
      ),
      body: Container(

        color: Colors.grey[200],
        child: ListView(
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
    );
  }
}
