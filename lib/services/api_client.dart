import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String? _token;

  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  Future<void> setToken(String? token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('auth_token', token);
    } else {
      await prefs.remove('auth_token');
    }
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Map<String, String> _getHeaders({bool requiresAuth = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = false,
  }) async {
    if (requiresAuth) {
      await getToken();
    }

    var uri = Uri.parse('${ApiConfig.apiBaseUrl}$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(
      uri,
      headers: _getHeaders(requiresAuth: requiresAuth),
    );

    return response;
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    if (requiresAuth) {
      await getToken();
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.apiBaseUrl}$endpoint'),
      headers: _getHeaders(requiresAuth: requiresAuth),
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  Future<http.Response> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    if (requiresAuth) {
      await getToken();
    }

    final response = await http.delete(
      Uri.parse('${ApiConfig.apiBaseUrl}$endpoint'),
      headers: _getHeaders(requiresAuth: requiresAuth),
    );

    return response;
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    if (requiresAuth) {
      await getToken();
    }

    final response = await http.put(
      Uri.parse('${ApiConfig.apiBaseUrl}$endpoint'),
      headers: _getHeaders(requiresAuth: requiresAuth),
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }
}

