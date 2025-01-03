import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyService {

//fetch all companies

  Future<List<dynamic>> fetchCompanyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    // Check if access token exists
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token is missing.');
    }

    // Get the base URL from the .env file
    final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

    // Check if the base URL is missing
    if (_baseUrl.isEmpty) {
      throw Exception('Base URL not found in environment variables.');
    }

    try {
      // Make an HTTP GET request, passing the access token in the Authorization header
      final response = await http.get(
        Uri.parse('$_baseUrl/admin/businessprofiles'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> companies = jsonDecode(response.body);

        // Cache response using shared preferences
        prefs.setString('companyList', response.body);

        return companies;
      } else {
        throw Exception("Failed to load company list: ${response.statusCode}");
      }
    } catch (e) {
      // Try to load cached data in case of error
      final cachedData = prefs.getString('companyList');
      if (cachedData != null) {
        return jsonDecode(cachedData);
      }
      throw Exception("Failed to fetch company list: $e");
    }
  }
}
