import 'dart:convert';
import '../config/api_config.dart';
import '../models/auth_models.dart';
import 'api_client.dart';

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
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<AuthResponse> createAccount(
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    try {
      final request = CreateAccountRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      final response = await _apiClient.post(
        ApiConfig.createAccountEndpoint,
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
        throw Exception('Account creation failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Account creation error: $e');
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

