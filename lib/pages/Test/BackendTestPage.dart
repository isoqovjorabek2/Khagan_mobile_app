import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/api_client.dart';
import '../../services/product_service.dart';
import '../../config/api_config.dart';

class BackendTestPage extends StatefulWidget {
  const BackendTestPage({super.key});

  @override
  State<BackendTestPage> createState() => _BackendTestPageState();
}

class _BackendTestPageState extends State<BackendTestPage> {
  final List<TestResult> _results = [];
  bool _isRunning = false;
  final AuthService _authService = AuthService();
  final ApiClient _apiClient = ApiClient();
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Connectivity Test'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Backend URL: ${ApiConfig.baseUrl}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'API Base URL: ${ApiConfig.apiBaseUrl}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _isRunning ? null : _runAllTests,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: _isRunning
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Run All Tests'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final result = _results[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: result.success ? Colors.green.shade50 : Colors.red.shade50,
                  child: ListTile(
                    leading: Icon(
                      result.success ? Icons.check_circle : Icons.error,
                      color: result.success ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      result.testName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${result.statusCode ?? "N/A"}'),
                        if (result.message != null)
                          Text(
                            result.message!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        if (result.details != null)
                          Text(
                            result.details!,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isRunning = true;
      _results.clear();
    });

    // Test 1: Base URL connectivity
    await _testBaseUrl();

    // Test 2: Products endpoint
    await _testProductsEndpoint();

    // Test 3: Categories endpoint
    await _testCategoriesEndpoint();

    // Test 4: Login endpoint
    await _testLoginEndpoint();

    // Test 5: Create account endpoint
    await _testCreateAccountEndpoint();

    // Test 6: Request OTP endpoint
    await _testRequestOTPEndpoint();

    setState(() {
      _isRunning = false;
    });
  }

  Future<void> _testBaseUrl() async {
    try {
      final response = await _apiClient.get('/category/products/');
      _addResult(
        'Base URL Connectivity',
        response.statusCode,
        'Successfully connected to backend',
        null,
        response.statusCode < 500,
      );
    } catch (e) {
      _addResult(
        'Base URL Connectivity',
        null,
        'Failed to connect',
        e.toString(),
        false,
      );
    }
  }

  Future<void> _testProductsEndpoint() async {
    try {
      final response = await _apiClient.get('/category/products/');
      _addResult(
        'Products Endpoint',
        response.statusCode,
        response.statusCode == 200 ? 'Products retrieved successfully' : 'Endpoint responded but returned ${response.statusCode}',
        response.statusCode == 200 ? null : response.body.substring(0, response.body.length > 100 ? 100 : response.body.length),
        response.statusCode < 500,
      );
    } catch (e) {
      _addResult(
        'Products Endpoint',
        null,
        'Failed to connect',
        e.toString(),
        false,
      );
    }
  }

  Future<void> _testCategoriesEndpoint() async {
    try {
      final response = await _apiClient.get('/category/categories/');
      _addResult(
        'Categories Endpoint',
        response.statusCode,
        response.statusCode == 200 ? 'Categories retrieved successfully' : 'Endpoint responded but returned ${response.statusCode}',
        null,
        response.statusCode < 500,
      );
    } catch (e) {
      _addResult(
        'Categories Endpoint',
        null,
        'Failed to connect',
        e.toString(),
        false,
      );
    }
  }

  Future<void> _testLoginEndpoint() async {
    try {
      await _authService.login('test@test.com', 'wrongpassword');
      _addResult(
        'Login Endpoint',
        200,
        'Login endpoint is accessible',
        null,
        true,
      );
    } catch (e) {
      final errorMsg = e.toString();
      final isNetworkError = errorMsg.contains('Network error') ||
          errorMsg.contains('timeout') ||
          errorMsg.contains('Unable to connect');
      
      _addResult(
        'Login Endpoint',
        null,
        isNetworkError ? 'Network error - backend unreachable' : 'Endpoint accessible (auth error expected)',
        errorMsg,
        !isNetworkError,
      );
    }
  }

  Future<void> _testCreateAccountEndpoint() async {
    try {
      await _authService.createAccount('test@test.com', 'test123');
      _addResult(
        'Create Account Endpoint',
        200,
        'Create account endpoint is accessible',
        null,
        true,
      );
    } catch (e) {
      final errorMsg = e.toString();
      final isNetworkError = errorMsg.contains('Network error') ||
          errorMsg.contains('timeout') ||
          errorMsg.contains('Unable to connect');
      
      _addResult(
        'Create Account Endpoint',
        null,
        isNetworkError ? 'Network error - backend unreachable' : 'Endpoint accessible (validation error expected)',
        errorMsg,
        !isNetworkError,
      );
    }
  }

  Future<void> _testRequestOTPEndpoint() async {
    try {
      final result = await _authService.requestOTP('test@test.com');
      _addResult(
        'Request OTP Endpoint',
        200,
        result ? 'OTP request successful' : 'OTP request endpoint responded',
        null,
        true,
      );
    } catch (e) {
      final errorMsg = e.toString();
      final isNetworkError = errorMsg.contains('Network error') ||
          errorMsg.contains('timeout') ||
          errorMsg.contains('Unable to connect');
      
      _addResult(
        'Request OTP Endpoint',
        null,
        isNetworkError ? 'Network error - backend unreachable' : 'Endpoint accessible',
        errorMsg,
        !isNetworkError,
      );
    }
  }

  void _addResult(String testName, int? statusCode, String message, String? details, bool success) {
    setState(() {
      _results.add(TestResult(
        testName: testName,
        statusCode: statusCode,
        message: message,
        details: details,
        success: success,
      ));
    });
  }
}

class TestResult {
  final String testName;
  final int? statusCode;
  final String message;
  final String? details;
  final bool success;

  TestResult({
    required this.testName,
    this.statusCode,
    required this.message,
    this.details,
    required this.success,
  });
}

