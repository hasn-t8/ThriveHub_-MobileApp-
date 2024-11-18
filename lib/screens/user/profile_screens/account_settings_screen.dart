import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:thrive_hub/widgets/appbar.dart';
import '../../../widgets/input_fields.dart';
import 'package:thrive_hub/core/utils/email_validator.dart'; // Import the file where emailValidator is defined.

class AccountSettingsScreen extends StatefulWidget {
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isFormModified = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to detect changes
    _firstNameController.addListener(_onFieldChange);
    _lastNameController.addListener(_onFieldChange);
    _dateController.addListener(_onFieldChange);
    _locationController.addListener(_onFieldChange);
    _emailController.addListener(_onFieldChange);
  }

  void _onFieldChange() {
    setState(() {
      _isFormModified = true;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _isFormModified = true; // Update form modification state
      });
    }
  }

  void _validateAndSubmit() {
    final email = _emailController.text.trim();
    final validationError = emailValidator(email);

    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    // Handle the successful submission of the form here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Form submitted successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account Settings',
        showBackButton: true,
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFFFFFFF),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField(
                    labelText: 'First Name',
                    controller: _firstNameController,
                      labelColor: Color(0xFF5A5A5A),// Custom label color
                      labelFontSize: 14, // Custom label font size
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1F000000), // #0000001F as RGBA (Flutter equivalent)
                          offset: Offset(0, 1), // Horizontal offset: 0, Vertical offset: 1
                          blurRadius: 11, // Blur radius
                          spreadRadius: 1, // Spread radius
                        ),
                      ],
                  ),
                  SizedBox(height: 16),
                  CustomInputField(
                    labelText: 'Last Name',
                    controller: _lastNameController,
                    labelColor: Color(0xFF5A5A5A), // Custom label color
                    labelFontSize: 14, // Custom label font size
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000), // #0000001F as RGBA (Flutter equivalent)
                        offset: Offset(0, 1), // Horizontal offset: 0, Vertical offset: 1
                        blurRadius: 11, // Blur radius
                        spreadRadius: 1, // Spread radius
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomInputField(
                        labelText: 'Date of Birth',
                        hintText: '01/01/2000', // Pass custom hint text here
                        controller: _dateController,
                        labelFontSize: 14, // Custom label font size
                        labelColor: Color(0xFF5A5A5A), // Custom label color
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1F000000), // #0000001F as RGBA (Flutter equivalent)
                            offset: Offset(0, 1), // Horizontal offset: 0, Vertical offset: 1
                            blurRadius: 11, // Blur radius
                            spreadRadius: 1, // Spread radius
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  CustomInputField(
                    labelText: 'Location',
                    labelFontSize: 14, // Custom label font size
                    controller: _locationController,
                    labelColor: Color(0xFF5A5A5A), // Custom label color
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000), // #0000001F as RGBA (Flutter equivalent)
                        offset: Offset(0, 1), // Horizontal offset: 0, Vertical offset: 1
                        blurRadius: 11, // Blur radius
                        spreadRadius: 1, // Spread radius
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  CustomInputField(
                    labelText: 'Email',
                    hintText: 'mail.example@gmail.com', // Pass custom hint text here
                    controller: _emailController,
                    labelFontSize: 14, // Custom label font size
                    labelColor: Color(0xFF5A5A5A), // Custom label color
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000), // #0000001F as RGBA (Flutter equivalent)
                        offset: Offset(0, 1), // Horizontal offset: 0, Vertical offset: 1
                        blurRadius: 11, // Blur radius
                        spreadRadius: 1, // Spread radius
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormModified ? _validateAndSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormModified ? Colors.black : Color(0xFFA5A5A5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: _isFormModified ? Colors.white : Color(0xFF000000),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
