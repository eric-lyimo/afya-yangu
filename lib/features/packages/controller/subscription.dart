import 'dart:convert';
import 'package:http/http.dart' as http;

class PackagesController {
  static final PackagesController _instance = PackagesController._internal();

  factory PackagesController() {
    return _instance;
  }

  PackagesController._internal();

  // The base URL for the API
  final String baseUrl = 'https://your-api-url.com'; // Replace with your API's base URL

  // Common headers for the API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer YOUR_TOKEN', // Uncomment if authentication is required
  };

  // Insert a new subscription
  Future<Map<String, dynamic>?> insertSubscription(Map<String, dynamic> subscription) async {
    try {
      final url = Uri.parse('$baseUrl/subscriptions');
      final response = await http.post(url, headers: _headers, body: json.encode(subscription));
      return _processResponse(response);
    } catch (e) {
      throw Exception('Failed to insert subscription: $e');
    }
  }

  // Load subscription details for a user
  Future<Map<String, dynamic>?> loadSubscription(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/subscriptions/$userId');
      final response = await http.get(url, headers: _headers);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Failed to load subscription: $e');
    }
  }

  // Update an existing subscription
  Future<void> updateSubscription(Map<String, dynamic> subscription) async {
    try {
      final url = Uri.parse('$baseUrl/subscriptions');
      final response = await http.put(url, headers: _headers, body: json.encode(subscription));
      _processResponse(response);
    } catch (e) {
      throw Exception('Failed to update subscription: $e');
    }
  }

  // Unsubscribe a user from their package
  Future<Map<String, dynamic>?> unsubscribe(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/subscriptions/$userId');
      final response = await http.delete(url, headers: _headers);
      return _processResponse(response);
    } catch (e) {
      throw Exception('Failed to unsubscribe: $e');
    }
  }

  // Process the response from the API
  Map<String, dynamic>? _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body); // Decode the response body to a Map
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
}
