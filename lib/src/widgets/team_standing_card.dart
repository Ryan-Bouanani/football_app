import 'package:flutter/material.dart';
import '../api_service.dart';

class TeamDetailsScreen extends StatefulWidget {
  final int teamId;

  const TeamDetailsScreen({
    super.key,
    required this.teamId,
  });

  @override
  _TeamDetailsScreenState createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic>? _squadDetails;
  List<dynamic>? _filteredSquadDetails;
  String _searchCriteria = 'name';
  String? _teamName;
  String? _teamCrest;
  bool _isLoading = true;
  List<String> competitions = [];
  String selectedCompetition = '';
  String competitionName = '';

  @override
  void initState() {
    super.initState();
    _fetchTeamData();
    _fetchCompetitions();
  }

  void _fetchCompetitions() {
    _apiService.fetchCompetitions((competitionCodes) {
      setState(() {
        competitions = competitionCodes;
        selectedCompetition = competitions.contains('FL1')
            ? 'FL1'
            : (competitions.isNotEmpty ? competitions[0] : '');
      });
    }, () {
      // Gestion d'erreur si nécessaire
    });
  }

  void _fetchTeamData() {
    setState(() {
      _isLoading = true;
    });

    _apiService.fetchTeamDetails(
      teamId: widget.teamId,
      onSuccess: (teamDetails) {
        setState(() {
          _squadDetails = teamDetails['squad'];
          _filteredSquadDetails = _squadDetails;
          _teamName = teamDetails['name'];
          _teamCrest = teamDetails['crest'];
          _isLoading = false;
        });
      },
      onError: () {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du chargement des données de l\'équipe'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  void _filterPlayers(String query) {
    setState(() {
      _filteredSquadDetails = _squadDetails?.where((player) {
        final searchValue = _getSearchValue(player);
        return searchValue.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  String _getSearchValue(Map<String, dynamic> player) {
    switch (_searchCriteria) {
      case 'nationality':
        return player['nationality']?.toString() ?? '';
      case 'postes':
        return player['position']?.toString() ?? '';
      case 'name':
      default:
        return player['name']?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.sports_soccer);
                },
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _teamName ?? 'Détails de l\'équipe',
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          DropdownButton<String>(
            value: selectedCompetition.isNotEmpty ? selectedCompetition : null,
            dropdownColor: Colors.blue,
            icon: const Icon(Icons.arrow_downward, color: Colors.white),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCompetition = newValue;
                  // Vous pouvez ajouter ici une logique pour charger les données
                  // de la nouvelle compétition si nécessaire
                });
              }
            },
            items: competitions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _fetchTeamData(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: _filterPlayers,
                            decoration: const InputDecoration(
                              labelText: 'Rechercher un joueur',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _searchCriteria,
                          items: const [
                            DropdownMenuItem(
                              value: 'name',
                              child: Text('Nom'),
                            ),
                            DropdownMenuItem(
                              value: 'nationality',
                              child: Text('Nationalité'),
                            ),
                            DropdownMenuItem(
                              value: 'postes',
                              child: Text('Poste'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _searchCriteria = value;
                              });
                            }
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
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
                                    'Poste : ${player?['position'] ?? 'Non spécifié'}',
                                  ),
                                  Text(
                                    'Nationalité : ${player?['nationality'] ?? 'N/A'}',
                                  ),
                                  Text(
                                    'Date de naissance : ${player?['dateOfBirth'] ?? 'N/A'}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
