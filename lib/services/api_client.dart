import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

/// HTTP Client wrapper that automatically attaches Authorization Bearer tokens,
/// parses common response formats, and handles network exceptions.
class ApiClient {
  // Update this URL once your backend server is deployed
  static const String defaultBaseUrl = 'https://api.linkdesk.io/api/v1';

  final String baseUrl;
  final http.Client _client;
  final AuthService _authService;

  ApiClient({
    this.baseUrl = defaultBaseUrl,
    http.Client? client,
    AuthService? authService,
  })  : _client = client ?? http.Client(),
        _authService = authService ?? AuthService();

  /// Default headers with Bearer token if authenticated
  Map<String, String> _buildHeaders([Map<String, String>? extraHeaders]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = _authService.authToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  /// GET request
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.get(uri, headers: _buildHeaders(headers));
    return _handleResponse(response);
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.post(
      uri,
      headers: _buildHeaders(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.put(
      uri,
      headers: _buildHeaders(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  /// DELETE request
  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await _client.delete(uri, headers: _buildHeaders(headers));
    return _handleResponse(response);
  }

  /// Response interceptor handling status codes
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      _authService.clearSession();
      throw ApiException(statusCode: 401, message: 'Session expired. Please log in again.');
    } else {
      String errorMessage = 'Request failed with code ${response.statusCode}';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('message')) {
          errorMessage = body['message'].toString();
        }
      } catch (_) {}
      throw ApiException(statusCode: response.statusCode, message: errorMessage);
    }
  }
}

/// Custom Exception class for HTTP network errors
class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({required this.statusCode, required this.message});

  @override
  String toString() => message;
}

