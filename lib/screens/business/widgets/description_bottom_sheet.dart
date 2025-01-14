import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReusableBottomSheet extends StatefulWidget {
  final TextEditingController descriptionController;
  final File? initialSelectedImage;
  final Function(String, File?) onSave;
  final Function()? onClose;

  const ReusableBottomSheet({
    required this.descriptionController,
    required this.onSave,
    this.onClose,
    this.initialSelectedImage,
  });

  @override
  _ReusableBottomSheetState createState() => _ReusableBottomSheetState();
}

class _ReusableBottomSheetState extends State<ReusableBottomSheet> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialSelectedImage;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Set entire sheet color to white
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
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
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Text(
                    'Edit Description',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: widget.onClose ?? () => Navigator.pop(context),
                    child: CircleAvatar(
                      radius: 8.5,
                      backgroundColor: Color(0xFF8E8E93),
                      child: Icon(Icons.close, size: 17, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 20),
              // Description text field
              Container(
                width: double.infinity,
                height: 154,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFFBFBFB),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.12),
                      blurRadius: 10,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: widget.descriptionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Type your Description here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Attach Photo button
              TextButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.attach_file, color: Color(0xFFB3B3B3)),
                label: Text(
                  "Attach Photo",
                  style: TextStyle(color: Color(0xFFB3B3B3)),
                ),
              ),
              // Show selected image with remove option
              if (_selectedImage != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${_selectedImage!.path.split('/').last}',
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                        });
                      },
                    ),
                  ],
                ),
              // Save button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSave(widget.descriptionController.text, _selectedImage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
