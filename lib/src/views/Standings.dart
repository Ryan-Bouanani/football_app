import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StandingsPage extends StatefulWidget {
  @override
  _StandingsPageState createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  List<dynamic> standings = [];

  @override
  void initState() {
    super.initState();
    fetchStandings();
  }

  Future<void> fetchStandings() async {
    final response = await http.get(
      Uri.parse('https://api.football-data.org/v4/competitions/FL1/standings'),
      headers: {
        'X-Auth-Token': '6356f969be944f7e86bbf5edc16a7d74',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        standings = data['standings'][0]['table'];
      });
    } else {
      print('Erreur de chargement: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Classement Ligue 1')),
      body: ListView.builder(
        itemCount: standings.length,
        itemBuilder: (context, index) {
          final team = standings[index];
          return ListTile(
            leading: Text('${team['position']}'),
            title: Text(team['team']['name']),
            trailing: Text('${team['points']} pts'),
          );
        },
      ),
    );
  }
}