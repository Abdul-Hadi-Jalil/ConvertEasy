import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';

void main() async {
  runApp(const ConvertEasy());
}

class ConvertEasy extends StatelessWidget {
  const ConvertEasy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convertly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3B82F6),
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: CardThemeData(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black.withOpacity(0.05),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
