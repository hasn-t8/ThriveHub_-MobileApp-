import 'dart:convert';
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
}