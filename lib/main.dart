import 'package:flutter/material.dart';
import 'package:helloworld/pages/Auth/StartPage.dart';
import 'package:helloworld/pages/Cart/CartPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khagan App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: CartPage(),
    );
  }
}
