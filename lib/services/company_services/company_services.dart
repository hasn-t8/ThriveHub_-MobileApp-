import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyService {
  // Helper function to save the businessId locally
  Future<void> _saveBusinessIdLocally(String businessId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing list of visited business IDs
    List<String> visitedBusinesses =
        prefs.getStringList('visitedBusinessIds') ?? [];

    // Add the new businessId to the list if it doesn't already exist
    if (!visitedBusinesses.contains(businessId)) {
      visitedBusinesses.add(businessId);
      await prefs.setStringList('visitedBusinessIds', visitedBusinesses);
    }
  }

// Helper function to retrieve the list of visited business IDs
  Future<List<String>> getVisitedBusinessIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('visitedBusinessIds') ?? [];
  }


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
        if (parsedResponse is Map<String, dynamic> &&
            parsedResponse['data'] is List) {
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
    final String url =
        '$_baseUrl/businessprofiles/$businessId'; // Adjust the endpoint as needed
    // Save the businessId to SharedPreferences
    await _saveBusinessIdLocally(businessId);
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Successful response
        return json.decode(response.body);
      } else {
        // Handle server errors
        throw Exception(
            'Failed to load business profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle client-side errors
      throw Exception('Failed to fetch business profile: $e');
    }
  }

  ///get reviews by businessid
  Future<List<Map<String, dynamic>>> getReviewsByBusinessId(
      String businessId) async {
    final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
    final String apiUrl = "$_baseUrl/reviews/business/$businessId";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> reviewsJson = json.decode(response.body);
        final filteredReviews = reviewsJson
            .where((review) => review['approval_status'] == 'true')
            .map((review) => Map<String, dynamic>.from(review))
            .toList();
        return filteredReviews;
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
      final filteredData = data
          .where((review) => review['approval_status'] == 'true')
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      return filteredData;
    } else {
      throw Exception('Failed to fetch reviews: ${response.statusCode}');
    }
  }
  //get all reviews by user id

  Future<List<Map<String, dynamic>>> fetchAllReviewsbyuserid() async {
    final prefs = await SharedPreferences.getInstance();
    final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      throw Exception('Access token is missing');
    }

    final url = Uri.parse('$_baseUrl/reviews');
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

//reply to review by business owner
  Future<bool> replyToReview(String reviewId, String replyText) async {
    final prefs = await SharedPreferences.getInstance();
    final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
    final accessToken = prefs.getString('access_token');
    final url = Uri.parse('$_baseUrl/reviews/$reviewId/replies');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final body = {'reply': replyText};

    try {
      final response =
          await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 201) {
        print('Reply successfully created201: ${response.body}');
        return true; // Success
      } else {
        print('Failed to reply to review: ${response.body}');
        return false; // Failure
      }
    } catch (error) {
      print('Error replying to review: $error');
      throw error;
    }
  }

  //get all replies of a review for business owner
  Future<List<Map<String, dynamic>>?> getRepliesByReviewId(
      String reviewId) async {
    final prefs = await SharedPreferences.getInstance();
    final String _baseUrl = dotenv.env['BASE_URL'] ?? '';
    final accessToken = prefs.getString('access_token');

    final url = Uri.parse('$_baseUrl/reviews/$reviewId/replies');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          // If the API returns a list of replies, ensure each element is a Map
          final replies =
              data.map((reply) => Map<String, dynamic>.from(reply)).toList();
          print('Replies fetched (List): $replies');
          return replies;
        } else if (data is Map<String, dynamic>) {
          // If the API returns a single reply, wrap it in a list
          final replies = [data];
          print('Replies fetched (Single Map): $replies');
          return replies;
        } else {
          print('Unexpected response format: $data');
          return null;
        }
      } else {
        print('Failed to fetch replies: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching replies: $e');
      return null;
    }
  }
}
