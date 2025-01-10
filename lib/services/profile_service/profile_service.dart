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

  // Function to create a business-profile with the profile
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

  //to fetch business profile by business id
  Future<Map<String, dynamic>> fetchBusinessDetails() async {
    final accessToken = await _getAccessToken();
    final prefs = await SharedPreferences.getInstance();
    final businessID= prefs.getString('business_profile_id') ?? '';
    print("Access Token:  $businessID ");

    final url = Uri.parse('$_baseUrl/businessprofiles/$businessID');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch business details');
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
  Future<http.Response> uploadImage(String filePath) async {
    final accessToken = await _getAccessToken();

    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/upload-profile-image'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken', // Attach the token
        'Content-Type': 'multipart/form-data',
      });

      // Attach the file
      request.files.add(await http.MultipartFile.fromPath(
        'profileImage', // The field name expected by your API
        filePath,
      ));

      // Send the request
      final streamedResponse = await request.send();

      // Convert StreamedResponse to Response
      final response = await http.Response.fromStream(streamedResponse);

      // Check status code and throw an exception if necessary
      if (response.statusCode != 200) {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }


  // Upload logo API for business
  Future<bool> businessUploadLogo(File logoFile) async {
    final prefs = await SharedPreferences.getInstance();
    final businessProfileId = prefs.getInt('business_profile_id') ?? -1;
    final accessToken = await _getAccessToken(); // Assuming this function retrieves the token
    print("proffff  $businessProfileId");

    if (businessProfileId == -1) {
      print('Business profile ID not found!');
      return false;
    }

    final uri = Uri.parse('$_baseUrl/upload-logo');
    final request = http.MultipartRequest('POST', uri);

    try {
      // Add the file to the request
      request.files.add(await http.MultipartFile.fromPath('logo', logoFile.path));

      // Add businessProfileId as a field in the body
      request.fields['businessProfileId'] = businessProfileId.toString();

      // Add the Authorization header
      request.headers['Authorization'] = 'Bearer $accessToken';

      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Logo uploaded successfully!');
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Failed to upload logo: ${response.statusCode}');
        print('Response body: $responseBody');
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
    // final profileId = prefs.getInt('profile_id') ?? -1;
    final businessProfileId = prefs.getInt('business_profile_id') ?? -1;

    if (businessProfileId == -1) {
      print('Error: businessProfile ID not found in SharedPreferences!');
      return false;
    }

    final accessToken = await _getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      print('Error: Access token is null or empty!');
      return false;
    }

    final uri = Uri.parse('$_baseUrl/businessprofiles/$businessProfileId');
    print('Requesting PUT $uri');
    print('Payload: ${jsonEncode(data)}');

    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      // Logging for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Handling response codes
      if (response.statusCode == 200) {
        print('Success: Data updated successfully!');
        return true;
      } else if (response.statusCode == 400) {
        print('Error: Bad Request. Please check the payload format.');
      } else if (response.statusCode == 401) {
        print('Error: Unauthorized. Please check the access token.');
      } else if (response.statusCode == 404) {
        print('Error: Profile not found. Ensure the profile ID is correct.');
      } else {
        print('Error: Unexpected response (${response.statusCode}) - ${response.body}');
      }

      return false;
    } on FormatException catch (e) {
      print('Error: Invalid JSON format - $e');
      return false;
    } on SocketException catch (e) {
      print('Error: Network issue - $e');
      return false;
    } catch (e) {
      print('Error: Unexpected error - $e');
      return false;
    }
  }



}