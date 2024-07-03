import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LogoutService {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'BASE_URL not found';

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      print("No access token found");
      return false;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'accessToken': accessToken}),
    );

    // if (response.statusCode == 200)
    if (response.statusCode == 404)
    {
      // Clear shared preferences on successful logout
      await prefs.clear();
      return true;
    } else {
      print("Failed to logout: ${response.statusCode} ${response.body}");
      return false;
    }
  }
}
