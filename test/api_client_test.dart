import 'package:flutter_test/flutter_test.dart';
import 'package:helloworld/services/api_client.dart';
import 'package:helloworld/config/api_config.dart';

void main() {
  group('ApiClient Tests', () {
    final apiClient = ApiClient();

    test('API Base URL should be correct', () {
      expect(ApiConfig.apiBaseUrl, 'https://khagan.univibe.uz/api/v1');
    });

    test('GET request to products endpoint', () async {
      try {
        final response = await apiClient.get(
          ApiConfig.productsEndpoint,
        );
        
        print('GET Products Status: ${response.statusCode}');
        print('GET Products Body: ${response.body}');
        
        expect(response.statusCode, isNotNull);
        // Accept any status code for connectivity test
        expect(response.statusCode, isA<int>());
      } catch (e) {
        print('GET Products Error: $e');
        // Test will fail if there's an error
        fail('Failed to connect to products endpoint: $e');
      }
    }, timeout: const Timeout(Duration(seconds: 35)));

    test('GET request to categories endpoint', () async {
      try {
        final response = await apiClient.get(
          ApiConfig.categoriesEndpoint,
        );
        
        print('GET Categories Status: ${response.statusCode}');
        print('GET Categories Body: ${response.body}');
        
        expect(response.statusCode, isNotNull);
        expect(response.statusCode, isA<int>());
      } catch (e) {
        print('GET Categories Error: $e');
        fail('Failed to connect to categories endpoint: $e');
      }
    }, timeout: const Timeout(Duration(seconds: 35)));

    test('POST request to login endpoint (should fail without credentials)', () async {
      try {
        final response = await apiClient.post(
          ApiConfig.loginEndpoint,
          body: {'email': 'test@test.com', 'password': 'test'},
        );
        
        print('POST Login Status: ${response.statusCode}');
        print('POST Login Body: ${response.body}');
        
        expect(response.statusCode, isNotNull);
        // Should return 400 or 401 without valid credentials
        expect([400, 401, 404, 422].contains(response.statusCode), isTrue);
      } catch (e) {
        print('POST Login Error: $e');
        // Network errors should be caught and rethrown with better messages
        expect(e.toString(), contains('Network error') || contains('timeout'));
      }
    }, timeout: const Timeout(Duration(seconds: 35)));
  });
}

