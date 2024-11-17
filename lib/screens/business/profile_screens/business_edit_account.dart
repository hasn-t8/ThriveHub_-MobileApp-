import 'package:flutter/material.dart';
import 'package:thrive_hub/business_screens/widgets/edit_account_form.dart';
import 'package:thrive_hub/widgets/alert_box.dart';


class BusinessAccountScreen extends StatefulWidget {
  @override
  _BusinessAccountScreenState createState() => _BusinessAccountScreenState();
}

class _BusinessAccountScreenState extends State<BusinessAccountScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _phoneCodeController = TextEditingController(text: "+1213");
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    Text(
                      "Add Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFB3B3B3),
                        spreadRadius: 0,
                        blurRadius: 11,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Type description here",
                        style: TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.attach_file, color: Color(0xFFB3B3B3)),
                  label: Text(
                    "Attach Photo",
                    style: TextStyle(color: Color(0xFFB3B3B3)),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertBox(
                            imagePath: 'assets/main.png', // Provide image path or leave null
                            title: 'Thank You!',
                            message: 'Your description will appear on the page in the near future.',
                          );
                        },
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                  ),

                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Business Account')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AccountForm(
          companyNameController: _companyNameController,
          websiteController: _websiteController,
          phoneCodeController: _phoneCodeController,
          phoneController: _phoneController,
          emailController: _emailController,
          onAddDescription: () => _showBottomSheet(context),
        ),
      ),
    );
  }
}
