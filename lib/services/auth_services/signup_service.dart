import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignUpService {
  // Get the base URL from the .env file
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'BASE_URL not found';

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'), // Constructing the register endpoint URL
        headers: <String, String>{
          'Content-Type': 'application/json',

        },
        body: jsonEncode(<String, dynamic>{
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('User registered successfully');
        return responseData;  // Return the response data
      } else {
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          // Get the first error message
          final firstErrorKey = errors.keys.first;
          final firstErrorMessage = errors[firstErrorKey].values.first;

          print('Failed to register user: $firstErrorMessage');
          throw Exception(firstErrorMessage);
        } else {
          final errorMessage = responseData['message'] ?? 'Failed to register user. Please check your credentials';
          print('Failed to register user: $errorMessage');
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow; // Rethrow the exception to propagate it up the call stack
    }
  }
}
