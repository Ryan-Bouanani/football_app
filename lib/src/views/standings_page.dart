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
  List<String> competitions = [];
  final ApiService apiService = ApiService();
  bool isLoading = true;
  String competitionName = '';
  String selectedCompetition = '';

  @override
  void initState() {
    super.initState();
    fetchCompetitions();
  }

  Future<void> fetchCompetitions() async {
    apiService.fetchCompetitions((competitionCodes) {
      setState(() {
        competitions = competitionCodes;
        selectedCompetition = competitions.contains('FL1') ? 'FL1' : (competitions.isNotEmpty ? competitions[0] : '');
        fetchStandings();
      });
    }, () {
      setState(() {
        isLoading = false;
      });
    });
  }


  Future<void> fetchStandings() async {
    if (selectedCompetition.isEmpty) return;
    setState(() {
      isLoading = true;
    });
    apiService.get(
      'https://api.football-data.org/v4/competitions/$selectedCompetition/standings',
      (data) {
        setState(() {
          standings = data['standings'][0]['table'];
          competitionName = data['competition']['name'];
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
          const Icon(Icons.table_chart, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            competitionName.isNotEmpty ? competitionName : 'Chargement...',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
      DropdownButton<String>(
        value: selectedCompetition.isNotEmpty ? selectedCompetition : null,
        dropdownColor: Colors.blue,
        icon: const Icon(Icons.arrow_downward, color: Colors.white),
        onChanged: (String? newValue) {
          setState(() {
            selectedCompetition = newValue!;
            fetchStandings(); 
          });
        },
        items: competitions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
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
