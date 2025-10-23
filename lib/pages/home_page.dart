import 'package:flutter/material.dart';

class home_page extends StatefulWidget {
  //to do
  final String title;
  const home_page({super.key, required this.title});

  @override
  State<home_page> createState() => _home_page();
}

class _home_page extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          'Hello, World!',
        ),
      ),
    );
  }
}
