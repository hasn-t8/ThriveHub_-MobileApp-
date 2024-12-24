import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Get the base URL from the .env file
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'BASE_URL not found';

  //register user
  Future<Map<String, dynamic>> registerUser({
    String? firstName,
    String? lastName,
    String? companyName,
    required String email,
    required String password,
    required List<String> userTypes, // Make sure userTypes is a List<String>
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'), // Constructing the register endpoint URL
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'full_name': firstName,
          // 'firstName': firstName,
          // 'lastName': lastName,
          // 'companyName': companyName,
          'email': email,
          'password': password,
          'types': userTypes,  // Pass the userTypes as a List<String>
        }),
      );

      // Decode the response body
      final responseData = jsonDecode(response.body);

      // Ensure the response is a Map<String, dynamic>
      if (responseData is Map<String, dynamic>) {
        if (response.statusCode == 201) {
          print('User registered successfully');
          return responseData;  // Return the response data
        } else if (response.statusCode == 409) {
          print('Email already exists');
          throw Exception('Email already exists');
        } else {
          // If the response contains errors, handle them
          if (responseData.containsKey('errors')) {
            final errors = responseData['errors'] as Map<String, dynamic>;
            final firstErrorKey = errors.keys.first;
            final firstErrorMessage = errors[firstErrorKey].values.first;
            print('Failed to register user: $firstErrorMessage');
            throw Exception(firstErrorMessage);
          } else {
            final errorMessage = responseData['message'] ?? 'Failed to register user';
            print('Failed to register user: $errorMessage');
            throw Exception(errorMessage);
          }
        }
      } else {
        // If the response is not a Map, handle it appropriately
        print('Unexpected response format: $responseData');
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow; // Rethrow the exception to propagate it up the call stack
    }
  }



  //login
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('Login successful: $responseData');
      return responseData;
    } else {
      print('Failed to login. Status code: ${response.statusCode}');
      print('Response body: $responseData');
      throw Exception('Failed to login: ${responseData['message']}');
    }
  }

  //logout
  Future<Map<String, dynamic>> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print("No access token found");
      return {'success': false, 'message': 'Access token not found'};
    }

    print("Access token retrieved: $accessToken"); // Logging access token
    print("Base URL: $_baseUrl"); // Logging base URL

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'accessToken': accessToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await prefs.clear(); // Clear shared preferences on successful logout
        return {'success': true, 'message': responseData['message'] ?? 'Logout successful'};
      } else {
        print("Failed to logout: ${response.statusCode} ${response.body}");
        return {'success': false, 'message': 'Logout failed'};
      }
    } catch (e) {
      print("Error during logout: $e");
      return {'success': false, 'message': 'An error occurred while logging out'};
    }
  }
}
