import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' if (dart.library.html) 'dart:html' as io;
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

    try {
      final response = await http
          .get(
            uri,
            headers: _getHeaders(requiresAuth: requiresAuth),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timeout: The server took too long to respond');
            },
          );

      return response;
    } on http.ClientException catch (e) {
      throw Exception('Network error: Unable to connect to server. Please check your internet connection. ${e.message}');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('Request timeout: The server took too long to respond. Please try again.');
      }
      throw Exception('Request failed: ${e.toString()}');
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    if (requiresAuth) {
      await getToken();
    }

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.apiBaseUrl}$endpoint'),
            headers: _getHeaders(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timeout: The server took too long to respond');
            },
          );

      return response;
    } on http.ClientException catch (e) {
      throw Exception('Network error: Unable to connect to server. Please check your internet connection. ${e.message}');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('Request timeout: The server took too long to respond. Please try again.');
      }
      throw Exception('Request failed: ${e.toString()}');
    }
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

  // Multipart POST for form data (used for file uploads)
  Future<http.Response> postMultipart(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, dynamic>? files,
    String? fileFieldName,
    bool requiresAuth = false,
  }) async {
    if (requiresAuth) {
      await getToken();
    }

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.apiBaseUrl}$endpoint'),
      );

      // Add headers (without Content-Type for multipart)
      final headers = <String, String>{
        'Accept': 'application/json',
      };
      if (requiresAuth && _token != null) {
        headers['Authorization'] = 'Bearer $_token';
      }
      request.headers.addAll(headers);

      // Add text fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add file fields (only on non-web platforms)
      if (files != null && !kIsWeb) {
        for (var entry in files.entries) {
          final file = entry.value as io.File;
          if (await file.exists()) {
            final fileStream = http.ByteStream(file.openRead());
            final fileLength = await file.length();
            final fileName = file.path.split('/').last;
            
            final multipartFile = http.MultipartFile(
              entry.key,
              fileStream,
              fileLength,
              filename: fileName,
            );
            request.files.add(multipartFile);
          }
        }
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout: The server took too long to respond');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);
      return response;
    } on http.ClientException catch (e) {
      throw Exception('Network error: Unable to connect to server. Please check your internet connection. ${e.message}');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('Request timeout: The server took too long to respond. Please try again.');
      }
      throw Exception('Request failed: ${e.toString()}');
    }
  }
}

