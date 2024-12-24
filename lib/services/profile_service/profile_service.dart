import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProfileService {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'BASE_URL not found';
  Future<void> createProfile(Profile profile) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/profiles'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode == 200) {
      // Profile created successfully
      print('Profile created');
    } else {
      // Error handling
      print('Failed to create profile');
    }
  }
}
