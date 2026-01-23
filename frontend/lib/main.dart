import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';

void main() {
  runApp(const ConvertEasy());
}

class ConvertEasy extends StatelessWidget {
  const ConvertEasy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blue),
      home: HomeScreen()
    );
  }
}
