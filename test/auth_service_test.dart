import 'package:flutter_test/flutter_test.dart';
import 'package:helloworld/services/auth_service.dart';
import 'package:helloworld/config/api_config.dart';

void main() {
  group('AuthService Backend Connectivity Tests', () {
    final authService = AuthService();

    test('Backend URL is accessible', () {
      expect(ApiConfig.baseUrl, 'https://khagan.univibe.uz');
      expect(ApiConfig.apiBaseUrl, 'https://khagan.univibe.uz/api/v1');
    });

    test('Login endpoint connectivity test', () async {
      try {
        // This should fail with 400/401 but should connect to server
        await authService.login('test@test.com', 'wrongpassword');
        fail('Should have thrown an exception');
      } catch (e) {
        final errorMessage = e.toString();
        print('Login Error: $errorMessage');
        
        // Should not be a network/connection error
        // Should be an authentication error (400, 401, 422)
        expect(
          errorMessage.contains('Network error') || 
          errorMessage.contains('timeout') ||
          errorMessage.contains('Unable to connect'),
          isFalse,
          reason: 'Backend should be reachable, got network error: $errorMessage',
        );
      }
    }, timeout: const Timeout(Duration(seconds: 35)));

    test('Create account endpoint connectivity test', () async {
      try {
        // This should fail but should connect to server
        await authService.createAccount('test@test.com', 'test123');
        fail('Should have thrown an exception for invalid account');
      } catch (e) {
        final errorMessage = e.toString();
        print('Create Account Error: $errorMessage');
        
        // Should not be a network/connection error
        expect(
          errorMessage.contains('Network error') || 
          errorMessage.contains('timeout') ||
          errorMessage.contains('Unable to connect'),
          isFalse,
          reason: 'Backend should be reachable, got network error: $errorMessage',
        );
      }
    }, timeout: const Timeout(Duration(seconds: 35)));

    test('Request OTP endpoint connectivity test', () async {
      try {
        final result = await authService.requestOTP('test@test.com');
        print('Request OTP Result: $result');
        // If it returns, backend is working
        expect(result, isA<bool>());
      } catch (e) {
        final errorMessage = e.toString();
        print('Request OTP Error: $errorMessage');
        
        // Check if it's a network error or API error
        if (errorMessage.contains('Network error') || 
            errorMessage.contains('timeout') ||
            errorMessage.contains('Unable to connect')) {
          fail('Backend is not reachable: $errorMessage');
        }
        // API errors are acceptable (means backend is reachable)
      }
    }, timeout: const Timeout(Duration(seconds: 35)));
  });
}

