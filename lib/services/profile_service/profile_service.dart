import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'BASE_URL not found';

  // Function to fetch the access token asynchronously
  Future<String?> _getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Function to create a profile with the profile data and access token
  Future<void> createAndUpdateProfile(Map<String, dynamic> profileData) async {
    try {
      // Fetch the access token
      final accessToken = await _getAccessToken();
      print("Access Token: $accessToken");

      if (accessToken == null) {
        print('Access token is missing!');
        return;
      }

      // Add the access token to the request headers
      final response = await http.post(
        Uri.parse('$_baseUrl/profiles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach the token here
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 200) {
        // Profile created successfully
        final responseBody = jsonDecode(response.body);
        print('Profile created successfully');
        print('Response: $responseBody');
      } else {
        // Error handling for failed request
        final responseBody = jsonDecode(response.body);
        print('Failed to create profile: ${response.statusCode}');
        print('Error message: ${responseBody['message'] ?? 'No message'}');
      }
    } catch (e) {
      print('Error creating profile: $e');
    }
  }

  // Function to fetch profile data
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final accessToken = await _getAccessToken();
      print("Access Token: $accessToken");

      if (accessToken == null) {
        print('Access token is missing!');
        return null;
      }

      // Make the GET request to fetch the profile data
      final response = await http.get(
        Uri.parse('$_baseUrl/profiles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Attach the token here
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('Profile fetched successfully');
        print('Response: $responseBody');
        return responseBody; // Assuming the profile data is under 'data' key
      } else {
        final responseBody = jsonDecode(response.body);
        print('Failed to fetch profile: ${response.statusCode}');
        print('Error message: ${responseBody['message'] ?? 'No message'}');
        return null;
      }
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  //upload user profile image
   Future<http.StreamedResponse> uploadImage(String filePath) async {
     final accessToken = await _getAccessToken();
    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST',
        Uri.parse('$_baseUrl/upload-profile-image'),);

      // Add headers (if required)
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken', // Attach the token here
        'Content-Type': 'multipart/form-data',
      });

      // Attach the file
      request.files.add(await http.MultipartFile.fromPath(
        'profileImage', // The field name expected by your API
        filePath,
      ));

      // Send the request
      return await request.send();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }


  // Upload logo API for business
  Future<bool> businessUploadLogo(File logoFile) async {
    final prefs = await SharedPreferences.getInstance();
    final businessProfileId = prefs.getInt('business_profile_id') ?? -1;

    if (businessProfileId == -1) {
      print('Business profile ID not found!');
      return false;
    }

    final uri = Uri.parse('$_baseUrl/business/$businessProfileId/upload-logo');
    final request = http.MultipartRequest('POST', uri);

    try {
      request.files.add(await http.MultipartFile.fromPath('logo', logoFile.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Logo uploaded successfully!');
        return true;
      } else {
        print('Failed to upload logo: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error uploading logo: $error');
      return false;
    }
  }

  // Profile setup API
  Future<bool> businessProfileSetup(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final profileId = prefs.getInt('profile_id') ?? -1;

    if (profileId == -1) {
      print('Profile ID not found!');
      return false;
    }

    final uri = Uri.parse('$_baseUrl/businessprofiles/$profileId');
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Data updated successfully!');
        return true;
      } else {
        print('Failed to update data: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error updating data: $error');
      return false;
    }
  }


}