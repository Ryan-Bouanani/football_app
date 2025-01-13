import 'package:flutter/material.dart';
import '../api_service.dart';
import '../widgets/player_card.dart';
import '../widgets/search_bar.dart';

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
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchTeamData();
  }

  void _fetchTeamData() {
    setState(() {
      _isLoading = true;
      _hasError = false;
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
          _hasError = true;
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
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorWidget()
              : _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Une erreur est survenue lors du chargement des données',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchTeamData,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async => _fetchTeamData(),
      child: Column(
        children: [
          SearchBarWidget(
            onSearch: _filterPlayers,
            searchCriteria: _searchCriteria,
            onCriteriaChanged: (value) {
              setState(() {
                _searchCriteria = value!;
              });
            },
          ),
          Expanded(
            child: _filteredSquadDetails?.isEmpty ?? true
                ? const Center(child: Text('Aucun joueur trouvé'))
                : ListView.builder(
                    itemCount: _filteredSquadDetails?.length ?? 0,
                    itemBuilder: (context, index) {
                      return PlayerCard(
                        player: _filteredSquadDetails![index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
