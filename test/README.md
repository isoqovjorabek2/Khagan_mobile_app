# Backend Connectivity Tests

This directory contains tests to verify backend connectivity and API functionality.

## Running Tests

### Unit Tests (Automated)

Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/api_client_test.dart
flutter test test/auth_service_test.dart
```

### Manual Test Page (UI)

To access the manual backend test page:

1. **Via Route**: Navigate to `/test` route in your app
2. **Via Code**: Add a button in your app that navigates to `BackendTestPage`
3. **Temporary Access**: You can temporarily set it as the home route in `main.dart`:
   ```dart
   home: const BackendTestPage(),
   ```

## Test Files

### `api_client_test.dart`
Tests the API client's ability to connect to backend endpoints:
- Base URL connectivity
- Products endpoint
- Categories endpoint
- Login endpoint (with invalid credentials)

### `auth_service_test.dart`
Tests authentication service endpoints:
- Login endpoint connectivity
- Create account endpoint connectivity
- Request OTP endpoint connectivity

### `BackendTestPage.dart` (Manual UI Test)
A Flutter page that provides a visual interface to test all backend endpoints:
- Shows backend URL
- Tests all endpoints with visual feedback
- Displays status codes and error messages
- Color-coded results (green for success, red for failure)

## Expected Results

### Successful Tests
- ✅ Status codes: 200 (success), 400/401/422 (expected auth/validation errors)
- ✅ Network connectivity established
- ✅ Backend responds (even with errors)

### Failed Tests
- ❌ Network errors (timeout, connection refused)
- ❌ Status codes: 500+ (server errors)
- ❌ Unable to reach backend

## Notes

- Tests use a 35-second timeout to account for slow connections
- Authentication tests use invalid credentials intentionally (to test connectivity, not auth)
- Network errors indicate backend is unreachable
- API errors (400, 401, 422) indicate backend is reachable but request is invalid (expected)

