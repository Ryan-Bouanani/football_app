import 'package:flutter/material.dart';
import 'src/views/main_page.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classement Ligue 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage()
    );
  }
}