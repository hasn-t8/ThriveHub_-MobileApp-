import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyService {
  Future<List<dynamic>> fetchCompanyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    // Check if access token exists
    // if (accessToken == null || accessToken.isEmpty) {
    //   throw Exception('Access token is missing.');
    // }

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
          // 'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic parsedResponse = jsonDecode(response.body);

        // Ensure the response has a 'data' key containing a list
        if (parsedResponse is Map<String, dynamic> && parsedResponse['data'] is List) {
          final List<dynamic> companies = parsedResponse['data'];

          // Cache response using shared preferences
          prefs.setString('companyList', jsonEncode(companies));
          print("Response Body: ${response.body}");
          return companies;
        } else {
          throw Exception('Unexpected API response structure.');
        }
      } else {
        throw Exception(
          "Failed to load company list: ${response.statusCode} - ${response.reasonPhrase}",
        );
      }
    } catch (e) {

      // Log the error for debugging
      print("Error fetching company list: $e");

      // Try to load cached data in case of error
      final cachedData = prefs.getString('companyList');
      if (cachedData != null) {
        print("Loading cached company list data.");
        return jsonDecode(cachedData);
      }

      throw Exception("Failed to fetch company list: $e");
    }
  }

  // Function to fetch business profile by ID
  Future<Map<String, dynamic>> getBusinessProfileById(String businessId) async {
    final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
    final String url = '$_baseUrl/businessprofiles/$businessId'; // Adjust the endpoint as needed
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Successful response
        return json.decode(response.body);
      } else {
        // Handle server errors
        throw Exception('Failed to load business profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle client-side errors
      throw Exception('Failed to fetch business profile: $e');
    }
  }
}
