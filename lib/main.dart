import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classement de la Ligue 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Classement de la Ligue 1'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> classement = [
      {
        'position': 1,
        'team': {
          'name': 'Paris Saint-Germain FC',
          'shortName': 'PSG',
          'crest': 'https://crests.football-data.org/524.png'
        },
        'playedGames': 13,
        'won': 10,
        'draw': 3,
        'lost': 0,
        'points': 33,
        'goalsFor': 37,
        'goalsAgainst': 11,
        'goalDifference': 26
      },
      {
          "position": 2,
          "team": {
              "id": 516,
              "name": "Olympique de Marseille",
              "shortName": "Marseille",
              "tla": "MAR",
              "crest": "https://crests.football-data.org/516.png"
          },
          "playedGames": 13,
          "form": null,
          "won": 8,
          "draw": 2,
          "lost": 3,
          "points": 26,
          "goalsFor": 29,
          "goalsAgainst": 17,
          "goalDifference": 12
      },
      {
          "position": 3,
          "team": {
              "id": 548,
              "name": "AS Monaco FC",
              "shortName": "Monaco",
              "tla": "ASM",
              "crest": "https://crests.football-data.org/548.png"
          },
          "playedGames": 13,
          "form": null,
          "won": 8,
          "draw": 2,
          "lost": 3,
          "points": 26,
          "goalsFor": 22,
          "goalsAgainst": 12,
          "goalDifference": 10
      },
      {
          "position": 4,
          "team": {
              "id": 521,
              "name": "Lille OSC",
              "shortName": "Lille",
              "tla": "LIL",
              "crest": "https://crests.football-data.org/521.png"
          },
          "playedGames": 13,
          "form": null,
          "won": 6,
          "draw": 5,
          "lost": 2,
          "points": 23,
          "goalsFor": 21,
          "goalsAgainst": 13,
          "goalDifference": 8
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: classement.length,
        itemBuilder: (context, index) {
          final equipe = classement[index];
          return ListTile(
            leading: Image.network(equipe['team']['crest']),
            title: Text(equipe['team']['name']),
            subtitle: Text(
              'Position: ${equipe['position']} - Points: ${equipe['points']} - Joués: ${equipe['playedGames']}',
            ),
          );
        },
      ),
    );
  }
}
