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
  String _searchCriteria = 'name'; // Default search criteria
  String? _teamName;
  String? _teamCrest;

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
      _teamName = teamDetails['name'];
      _teamCrest = teamDetails['crest']; // Use crest for the emblem
    });
  }

  void _filterPlayers(String query) {
    setState(() {
      _filteredSquadDetails = _squadDetails?.where((player) {
        final searchValue = _getSearchValue(player);
        return searchValue.contains(query.toLowerCase());
      }).toList();
    });
  }

  String _getSearchValue(Map<String, dynamic> player) {
    switch (_searchCriteria) {
      case 'nationality':
        return player['nationality']?.toLowerCase() ?? '';
      case 'postes':
        return player['position']?.toLowerCase() ?? '';
      case 'name':
      default:
        return player['name']?.toLowerCase() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            if (_teamCrest != null)
              Image.network(
                _teamCrest!,
                height: 30,
              ),
            SizedBox(width: 10),
            Text(_teamName ?? 'Team Players'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _filterPlayers,
                    decoration: InputDecoration(
                      labelText: 'Search Player',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: _searchCriteria,
                  items: [
                    DropdownMenuItem(value: 'name', child: Text('Name')),
                    DropdownMenuItem(
                        value: 'nationality', child: Text('Nationality')),
                    DropdownMenuItem(value: 'postes', child: Text('Postes')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _searchCriteria = value!;
                    });
                  },
                ),
              ],
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
                          Text(
                              'Poste : ${player?['position'] ?? 'Non spécifié'}'),
                          Text(
                              'Nationalité : ${player?['nationality'] ?? 'N/A'}'),
                          Text(
                              'Date de naissance : ${player?['dateOfBirth'] ?? 'N/A'}'),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scaleXY(begin: 0.75, end: 1.0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
