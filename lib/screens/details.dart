import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api.dart';

class TeamDetailsScreen extends StatefulWidget {
  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic>? _squadDetails;
  List<dynamic>? _filteredSquadDetails;

  @override
  void initState() {
    super.initState();
    _fetchTeamData();
  }

  Future<void> _fetchTeamData() async {
    final teamDetails = await _apiService.fetchTeamDetails();
    setState(() {
      _squadDetails = teamDetails['squad'];
      _filteredSquadDetails = _squadDetails;
    });
  }

  void _filterPlayers(String query) {
    setState(() {
      _filteredSquadDetails = _squadDetails?.where((player) {
        final playerName = player['name']?.toLowerCase() ?? '';
        return playerName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Players'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterPlayers,
              decoration: InputDecoration(
                labelText: 'Search Player',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSquadDetails?.length ?? 0,
              itemBuilder: (context, index) {
                final player = _filteredSquadDetails?[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(player?['name'] ?? 'Nom inconnu'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Poste : ${player?['position'] ?? 'Non spécifié'}'),
                          Text('Nationalité : ${player?['nationality'] ?? 'N/A'}'),
                          Text('Date de naissance : ${player?['dateOfBirth'] ?? 'N/A'}'),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scaleXY(begin: 0.95, end: 1.0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
