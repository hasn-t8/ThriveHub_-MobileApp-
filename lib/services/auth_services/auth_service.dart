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
    required List<String> userTypes,
  }) async {
    try {
      // Construct full name
      String fullName = '${firstName?.trim() ?? ''} ${lastName?.trim() ?? ''}'.trim();

      // Ensure required fields are valid
      if (email.isEmpty || password.isEmpty || userTypes.isEmpty) {
        throw Exception('Email, password, and user types are required.');
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName.isNotEmpty ? fullName : null,
          'org_name': companyName ?? ' ',
          'email': email,
          'password': password,
          'types': userTypes,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData is Map<String, dynamic>) {
        if (response.statusCode == 201) {
          print('User registered successfully');
          return responseData;
        } else if (response.statusCode == 409) {
          throw Exception('Email already exists');
        }else if (response.statusCode == 404) {
          throw Exception('name already exists');
        } else {
          final errors = responseData['errors'] as Map<String, dynamic>?;
          final firstErrorMessage = errors?.values.first?.toString() ?? 'Failed to register user';
          throw Exception(firstErrorMessage);
        }
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }



//Login
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
    } else if (response.statusCode == 403) {
      print('Please verify your account');
      throw Exception('403: Please verify your account');
    } else {
      print('Failed to login. Status code: ${response.statusCode}');
      print('Response body: $responseData');
      throw Exception('Failed to login: ${responseData['message']}');
    }
  }

//Activate account
  Future<bool> ActivateCodeApi(String email, String code) async {
    try {
      print("$email,$code");
      // Sending email and code to the API
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/activate-account/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': code,
        }),
      );

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle other status codes or errors
        throw Exception('Failed to verify code');
      }
    } catch (e) {
      // Handle errors (e.g., network issues)
      print('Error during API call: $e');
      return false;
    }
  }

  //Resend code
  Future<bool> ResendCodeApi(String email) async {
    try {
      print("Resending code to: $email");

      // Sending email to the API to resend the verification code
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/activate-account/get-code'),  // Adjust the endpoint URL accordingly
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
        }),
      );

      // Check if the response is successful (status code 200)
      if (response.statusCode == 200) {
        return true;  // Successfully resent the code
      } else {
        // Handle other status codes or errors
        throw Exception('Failed to resend code');
      }
    } catch (e) {
      // Handle errors (e.g., network issues)
      print('Error during API call: $e');
      return false;
    }
  }

  //Forget password
  Future<Map<String, dynamic>> sendResetPasswordEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forget-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Email sent successfully'};
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': 'User not found. Please check the email address.'};
      } else {
        final responseData = jsonDecode(response.body);
        return {'success': false, 'message': responseData['error'] ?? 'Failed to send email'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
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
        await prefs.clear();
        return {'success': true, 'message': responseData['message'] ?? 'Logout successful'};
      } else if (response.statusCode == 401) {
        await prefs.clear(); // Clear the token on 401
        return {'success': false, 'message': 'Unauthorized. Please log in again.'};
      } else {
        return {'success': false, 'message': 'Logout failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred while logging out'};
    }
  }


  Future<Map<String, dynamic>> changePassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/change-password'); // Replace with your endpoint
    try {
      print("$email");
      print("$token");
      print("$newPassword");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'token': token,
          'newPassword': newPassword,
        }),
      );
     print(response.statusCode);
      if (response.statusCode == 200) {
        // Successfully changed password
        return json.decode(response.body);
      } else {
        // Handle error responses
        return {
          'success': false,
          'message': json.decode(response.body)['message'] ??
              'An error occurred while resetting the password.',
        };
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues)
      return {
        'success': false,
        'message': 'An error occurred. Please check your network connection.',
      };
    }
  }
}
