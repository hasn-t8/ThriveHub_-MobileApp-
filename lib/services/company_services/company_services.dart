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

///get reviews by businessid
  Future<List<Map<String, dynamic>>> getReviewsByBusinessId(String businessId) async {
    final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
    final String apiUrl = "$_baseUrl/reviews/business/$businessId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final List<dynamic> reviewsJson = json.decode(response.body);
        return reviewsJson.map((review) => review as Map<String, dynamic>).toList();
      } else {
        // Handle non-200 responses
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors (e.g., network issues, parsing issues)
      throw Exception('Error fetching reviews: $e');
    }
  }
//get all reviews


 Future<List<Map<String, dynamic>>> fetchAllReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
    final url = Uri.parse('$_baseUrl/reviews');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to fetch reviews: ${response.statusCode}');
    }
  }
  //get all reviews by user id

  Future<List<Map<String, dynamic>>> fetchAllReviewsbyuserid() async {
    final prefs = await SharedPreferences.getInstance();
    final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
    final accessToken = prefs.getString('access_token');
    final userid = prefs.getInt('userid');
    if (accessToken == null) {
      throw Exception('Access token is missing');
    }

    final url = Uri.parse('$_baseUrl/reviews/business/$userid');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to fetch reviews: ${response.statusCode}');
    }
  }


  //creat a review by user
  Future<bool> createReview({
    required String businessId,
    required int rating,
    required String feedback,
  }) async {
    try {
      print('Starting createReview method');
      print('Business ID: $businessId');
      print('Rating: $rating');
      print('Feedback: $feedback');

      final prefs = await SharedPreferences.getInstance();
      final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
      final accessToken = prefs.getString('access_token');

      if (_baseUrl.isEmpty) {
        print('Base URL is missing');
        return false; // Indicate failure
      }

      if (accessToken == null) {
        print('Access token not found');
        return false; // Indicate failure
      }

      // API endpoint
      final String url = '$_baseUrl/reviews';
      print('API URL: $url');

      // Request body
      final Map<String, dynamic> body = {
        'businessId': businessId,
        'rating': rating,
        'feedback': feedback,
      };
      print('Request body: ${jsonEncode(body)}');

      // Send POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );

      print('Response received');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('Review created successfully');
        return true; // Indicate success
      } else {
        print('Failed to create review: ${response.statusCode}');
        print('Response details: ${response.body}');
        return false; // Indicate failure
      }
    } catch (e) {
      print('Error creating review: $e');
      return false; // Indicate failure
    }
  }


}
