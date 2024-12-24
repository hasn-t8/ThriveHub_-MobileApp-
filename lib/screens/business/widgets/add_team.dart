import 'package:flutter/material.dart';
import 'package:thrive_hub/widgets/input_fields.dart';

// Bottom Sheet for Adding a Team Member
class TeamMemberBottomSheet extends StatelessWidget {
  final Function(String, String, String) onAdd;
  final String? initialName;
  final String? initialEmail;
  final String? initialPosition;

  TeamMemberBottomSheet({
    required this.onAdd,
    this.initialName,
    this.initialEmail,
    this.initialPosition,

  });


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = initialName ?? '';
    emailController.text = initialEmail ?? '';
    positionController.text = initialPosition ?? '';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Add Team Member',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),

              // Form
              CustomInputField(
                labelText: 'Name',
                controller: nameController,
              ),
              SizedBox(height: 12),

              CustomInputField(
                labelText: 'Email',
                controller: emailController,
              ),
              SizedBox(height: 12),

              CustomInputField(
                labelText: 'Position',
                controller: positionController,
              ),
              SizedBox(height: 16.0),

              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = nameController.text;
                    final email = emailController.text;
                    final position = positionController.text;

                    if (name.isEmpty || email.isEmpty || position.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please fill all fields.')),
                      );
                      return;
                    }

                    onAdd(name, email, position);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}