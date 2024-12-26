import 'package:flutter/material.dart';
import 'package:thrive_hub/screens/business/widgets/add_team.dart';
import 'package:thrive_hub/screens/business/widgets/team_card.dart';
import 'package:thrive_hub/widgets/appbar.dart';
import 'package:thrive_hub/widgets/input_fields.dart';

class BusinessTeam extends StatefulWidget {
  @override
  _BusinessTeamState createState() => _BusinessTeamState();
}

class _BusinessTeamState extends State<BusinessTeam> {
  // Example of team members data, initially empty.
  List<Map<String, String>> teamMembers = [];

  // Method to add a team member
  void addTeamMember(String name, String email, String position) {
    setState(() {
      teamMembers.add({
        'name': name,
        'email': email,
        'position': position,
      });
    });
  }
  void editTeamMember(int index, String name, String email, String position) {
    setState(() {
      teamMembers[index] = {
        'name': name,
        'email': email,
        'position': position,
      };
    });
  }
  void removeTeamMember(int index) {
    setState(() {
      teamMembers.removeAt(index);
    });
  }

  // Show bottom sheet to add a team member
  void showAddTeamBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (_) => TeamMemberBottomSheet(
        onAdd: (name, email, position) {
          addTeamMember(name, email, position);
          Navigator.pop(context); // Close bottom sheet after adding

        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
      title: 'Team',
      showBackButton: true,
      centerTitle: true,
      onAddPressed: () => showAddTeamBottomSheet(context),
    ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: teamMembers.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display image
                  Image.asset(
                    'assets/splash_logo.png',
                    width: 241,
                    height: 264,
                  ),
                  SizedBox(height: 16.0),

                  // Display message
                  Text(
                    "You haven't added colleagues to your team yet.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Display "Add Team" button
                  SizedBox(
                    width: 343,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => showAddTeamBottomSheet(context),
                      child: Text(
                        'Add Team',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 19, vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          side: BorderSide(color: Color(0xFFA5A5A5)),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: teamMembers.length,
                itemBuilder: (context, index) {
                  final member = teamMembers[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TeamMemberCard(
                      name: member['name']!,
                      email: member['email']!,
                      position: member['position']!,
                      imageUrl:'https://via.placeholder.com/84', // Placeholder profile picture
                      onRemove: () => removeTeamMember(index), // Remove callback
                      onEdit: (name, email, position) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                          ),
                          builder: (_) => TeamMemberBottomSheet(
                            onAdd: (updatedName, updatedEmail, updatedPosition) {
                              editTeamMember(index, updatedName, updatedEmail, updatedPosition);
                            },
                            initialName: member['name']!,
                            initialEmail: member['email']!,
                            initialPosition: member['position']!,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
