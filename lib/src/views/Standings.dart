import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class StandingsPage extends StatefulWidget {
  @override
  _StandingsPageState createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  List<dynamic> standings = [];
  final dio = Dio();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStandings();
  }

  Future<void> fetchStandings() async {
    try {
      final response = await dio.get(
        'https://api.football-data.org/v4/competitions/FL1/standings',
        options: Options(
          headers: {
            'X-Auth-Token': '6356f969be944f7e86bbf5edc16a7d74'
          }
        )
      );
      
      setState(() {
        standings = response.data['standings'][0]['table'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Classement Ligue 1')),
      body: isLoading 
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
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