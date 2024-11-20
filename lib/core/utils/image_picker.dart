import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future<File?> pickImageWithUI(BuildContext context) async {
  return showModalBottomSheet<File?>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.of(context).pop(await pickImage(source: ImageSource.gallery));
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () async {
                Navigator.of(context).pop(await pickImage(source: ImageSource.camera));
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<File?> pickImage({required ImageSource source}) async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      return File(pickedFile.path); // Return the selected image as a File
    } else {
      print("No image selected.");
      return null;
    }
  } catch (e) {
    print("Error picking image: $e");
    return null;
  }
}
