import 'package:flutter/material.dart';
import '../api_service.dart';

// Page de classement
class StandingsPage extends StatefulWidget {
  const StandingsPage({super.key});

  @override
  _StandingsPageState createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  List<dynamic> standings = [];
  final ApiService apiService = ApiService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStandings();
  }

  Future<void> fetchStandings() async {
    apiService.get(
      'https://api.football-data.org/v4/competitions/FL1/standings',
      (data) {
        setState(() {
          standings = data['standings'][0]['table'];
          isLoading = false;
        });
      },
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
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
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => TeamDetailPage(team: team)
                    )
                  );
                },
                leading: Text('${team['position']}'),
                title: Text(team['team']['name']),
                trailing: Text('${team['points']} pts'),
              );
            },
          ),
    );
  }
}