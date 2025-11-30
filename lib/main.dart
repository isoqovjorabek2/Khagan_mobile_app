import 'package:flutter/material.dart';
import 'package:helloworld/pages/Auth/LoadingPage.dart';
import 'package:helloworld/pages/Auth/StartPage.dart';
import 'package:helloworld/pages/Auth/SignInPage.dart';
import 'package:helloworld/pages/Auth/SignUpPage.dart';
import 'package:helloworld/pages/MainNavigation.dart';
import 'package:helloworld/pages/Cart/CartPage.dart';
import 'package:helloworld/pages/Test/BackendTestPage.dart';
import 'package:helloworld/services/auth_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khagan App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/start': (context) => const StartPage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const MainNavigation(),
        '/cart': (context) => const CartPage(),
        '/test': (context) => const BackendTestPage(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      setState(() {
        _isAuthenticated = isLoggedIn;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingPage();
    }

    return _isAuthenticated ? const MainNavigation() : const LoadingPage();
  }
}
