import 'package:flutter/material.dart';
import 'package:football_app/src/themes/football_theme.dart';
import 'package:football_app/src/views/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classement Ligue 1',
      theme: FootballTheme.lightTheme,
      home: MainPage(),
    );
  }
}