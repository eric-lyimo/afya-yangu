import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mtmeru_afya_yangu/config/api.config.dart';

class ApiService {

  final Map<String, String> defaultHeaders;

  ApiService({
    this.defaultHeaders = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  });

  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>?> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return _handleRequest(() => http.get(uri, headers: _mergeHeaders(headers)));
  }

  Future<Map<String, dynamic>?> post( String endpoint, {Map<String, String>? headers,Map<String, dynamic>? body,}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return _handleRequest(() => http.post(
      uri,
      headers: _mergeHeaders(headers),
      body: jsonEncode(body),
    ));
  }

  Future<Map<String, dynamic>?> put(String endpoint, {Map<String, String>? headers,Map<String, dynamic>? body,}) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    return _handleRequest(() => http.put(
      uri,
      headers: _mergeHeaders(headers),
      body: jsonEncode(body),
    ));
  }

  Future<Map<String, dynamic>?> delete(String endpoint, {Map<String, String>? headers,}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return _handleRequest(() => http.delete(uri, headers: _mergeHeaders(headers)));
  }

  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders) {
    return {...defaultHeaders, if (customHeaders != null) ...customHeaders};
  }

  Future<Map<String, dynamic>?> _handleRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(const Duration(seconds: 10));
      final statusCode = response.statusCode;
      
      if (statusCode >= 200 && statusCode < 300) {
        return jsonDecode(response.body);
      } else if (statusCode == 401) {
        throw Exception("Unauthorized");
      } else if (statusCode == 403) {
        throw Exception("Forbidden");
      } else if (statusCode == 404) {
        throw Exception("Samahani  hakuna taarifa za ujauzito");
      } else if (statusCode >= 500) {
        throw Exception("Server error ($statusCode)");
      } else {
        throw Exception("Unexpected error ($statusCode)");
      }
    } on SocketException {
      throw Exception("No internet connection");
    } on TimeoutException {
      throw Exception("Request timed out");
    } on FormatException {
      throw Exception("Invalid response format");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
