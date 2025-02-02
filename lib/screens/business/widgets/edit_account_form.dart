import 'package:flutter/material.dart';

class AccountForm extends StatelessWidget {
  final TextEditingController companyNameController;
  final TextEditingController websiteController;
  final TextEditingController phoneCodeController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  AccountForm({
    Key? key,
    required this.companyNameController,
    required this.websiteController,
    required this.phoneCodeController,
    required this.phoneController,
    required this.emailController,
  }) : super(key: key);

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      hintStyle: TextStyle(color: Color(0xFFB3B3B3), fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color(0xFFB3B3B3),
          spreadRadius: 0,
          blurRadius: 11,
          offset: Offset(0, 1),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Company Name", "Thrive Hub", companyNameController),
                _buildTextField("Website", "www.thrivehub.com", websiteController),
                // _buildPhoneField(),
                _buildTextField("Email", "Enter email address", emailController, isEnabled: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hintText, TextEditingController controller, {bool isEnabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF5A5A5A),
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 24 / 14,
            letterSpacing: -0.36,
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(top: 4, bottom: 16),
          decoration: _boxDecoration(),
          child: TextField(
            controller: controller,
            enabled: isEnabled, // Dynamically control if the field is editable
            decoration: _inputDecoration(hintText),
            style: TextStyle(
              color: isEnabled ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: TextStyle(
            color: Color(0xFF5A5A5A),
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 24 / 14,
            letterSpacing: -0.36,
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(top: 8, bottom: 16),
          decoration: _boxDecoration(),
          child: Row(
            children: [
              Container(
                width: 70,
                decoration: BoxDecoration(
                  color: Color(0xFF888686),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: TextField(
                  controller: phoneCodeController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Color(0xFFB3B3B3), fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
