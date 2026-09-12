import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const _tokenKey = 'auth_token';

  final http.Client _client;
  String? _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  Future<Map<String, dynamic>> get(String path, {bool auth = false}) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(auth: auth),
      );
      return await _decode(response, auth: auth);
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = false,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(auth: auth),
        body: body != null ? jsonEncode(body) : null,
      );
      return await _decode(response, auth: auth);
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }
  }

  Future<Map<String, dynamic>> delete(String path, {bool auth = false}) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(auth: auth),
      );
      return await _decode(response, auth: auth);
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    }
  }

  Map<String, String> _headers({bool auth = false}) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (auth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> _decode(http.Response response, {bool auth = false}) async {
    Map<String, dynamic> body = {};

    if (response.body.isNotEmpty) {
      try {
        body = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        throw ApiException(
          _httpStatusMessage(response.statusCode),
          response.statusCode,
        );
      }
    }

    if (response.statusCode == 401 && auth) {
      await clearToken();
    }

    if (response.statusCode >= 400) {
      final message = body['message']?.toString();
      throw ApiException(
        message != null && message.isNotEmpty
            ? message
            : _httpStatusMessage(response.statusCode),
        response.statusCode,
      );
    }

    return body;
  }

  static String _httpStatusMessage(int statusCode) {
    switch (statusCode) {
      case 502:
        return 'Payment server error (502). Try FIB or try again.';
      case 503:
        return 'Service temporarily unavailable. Try again.';
      default:
        return 'Request failed ($statusCode)';
    }
  }
}

class ApiException implements Exception {
  ApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  const NetworkException();

  @override
  String toString() => 'network_error';
}
