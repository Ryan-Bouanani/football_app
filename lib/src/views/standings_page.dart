import 'package:flutter/material.dart';
import '../api_service.dart';
import '../widgets/team_standing_card.dart';

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
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.table_chart, color: Colors.white),
            SizedBox(width: 10),
            Text('Classement Ligue 1'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Fonctionnalité de filtrage potentielle
            },
          ),
        ],
      ),
      body: isLoading 
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            )
          )
        : RefreshIndicator(
            onRefresh: fetchStandings,
            child: ListView.builder(
              itemCount: standings.length,
              itemBuilder: (context, index) {
                final team = standings[index];
                return TeamStandingCard(
                  team: team, 
                  index: index, 
                  standings: standings
                );
              },
            ),
          ),
    );
  }
}