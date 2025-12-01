import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/api_config.dart';
import '../models/auth_models.dart';
import 'api_client.dart';
import 'dart:io' if (dart.library.html) 'dart:html' as io;

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiClient.post(
        ApiConfig.loginEndpoint,
        body: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(data);
        
        if (authResponse.token != null) {
          await _apiClient.setToken(authResponse.token);
        }
        
        return authResponse;
      } else {
        // Try to parse error message from response
        String errorMessage = 'Login failed';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map<String, dynamic>) {
            if (errorData.containsKey('message')) {
              errorMessage = errorData['message'].toString();
            } else if (errorData.containsKey('error')) {
              errorMessage = errorData['error'].toString();
            } else if (errorData.containsKey('detail')) {
              errorMessage = errorData['detail'].toString();
            } else {
              errorMessage = response.body;
            }
          }
        } catch (_) {
          errorMessage = response.body.isNotEmpty 
              ? response.body 
              : 'Login failed with status ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Re-throw if it's already a formatted exception
      if (e.toString().contains('Network error') || 
          e.toString().contains('timeout') ||
          e.toString().contains('Unable to connect')) {
        rethrow;
      }
      throw Exception('Login error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<AuthResponse> createAccount(
    String email,
    String password, {
    String? firstName,
    String? lastName,
    dynamic profileImage, // File on mobile, can be null on web
  }) async {
    try {
      // Prepare form fields
      final fields = <String, String>{
        'email': email,
        'password': password,
      };
      if (firstName != null && firstName.isNotEmpty) {
        fields['first_name'] = firstName;
      }
      if (lastName != null && lastName.isNotEmpty) {
        fields['last_name'] = lastName;
      }

      // Prepare files (only on non-web platforms)
      Map<String, dynamic>? files;
      if (profileImage != null && !kIsWeb) {
        files = <String, dynamic>{
          'profile_image': profileImage,
        };
      }

      // Use multipart POST for form data
      final response = await _apiClient.postMultipart(
        ApiConfig.createAccountEndpoint,
        fields: fields,
        files: files != null && files.isNotEmpty ? files : null,
        fileFieldName: profileImage != null ? 'profile_image' : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(data);
        
        if (authResponse.token != null) {
          await _apiClient.setToken(authResponse.token);
        }
        
        return authResponse;
      } else {
        // Try to parse error message from response
        String errorMessage = 'Account creation failed';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData is Map<String, dynamic>) {
            if (errorData.containsKey('message')) {
              errorMessage = errorData['message'].toString();
            } else if (errorData.containsKey('error')) {
              errorMessage = errorData['error'].toString();
            } else if (errorData.containsKey('detail')) {
              errorMessage = errorData['detail'].toString();
            } else if (errorData.containsKey('email')) {
              errorMessage = errorData['email'].toString();
            } else {
              errorMessage = response.body;
            }
          }
        } catch (_) {
          errorMessage = response.body.isNotEmpty 
              ? response.body 
              : 'Account creation failed with status ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Re-throw if it's already a formatted exception
      if (e.toString().contains('Network error') || 
          e.toString().contains('timeout') ||
          e.toString().contains('Unable to connect')) {
        rethrow;
      }
      throw Exception('Account creation error: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<bool> requestOTP(String email) async {
    try {
      final request = OTPRequest(email: email);
      final response = await _apiClient.post(
        ApiConfig.requestOtpEndpoint,
        body: request.toJson(),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('OTP request error: $e');
    }
  }

  Future<bool> verifyEmail(String email, String otpCode) async {
    try {
      final request = OTPVerifyRequest(email: email, otpCode: otpCode);
      final response = await _apiClient.post(
        ApiConfig.verifyEmailEndpoint,
        body: request.toJson(),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Email verification error: $e');
    }
  }

  Future<UserProfile> getProfile() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.getProfileEndpoint,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile.fromJson(data);
      } else {
        throw Exception('Failed to get profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Get profile error: $e');
    }
  }

  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await _apiClient.getToken();
    return token != null && token.isNotEmpty;
  }
}

