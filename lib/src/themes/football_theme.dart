import 'package:flutter/material.dart';

class FootballTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Color(0xFF1A5F7A),
      scaffoldBackgroundColor: Color(0xFFF0F4F8),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A5F7A),
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF1A5F7A),
        unselectedItemColor: Colors.grey,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black54),
      ),
    );
  }
}