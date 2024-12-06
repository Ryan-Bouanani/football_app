import 'package:flutter/material.dart';
import 'src/views/Standings.dart'; // Assurez-vous d'importer votre page de classement

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
      home: StandingsPage()
    );
  }
}