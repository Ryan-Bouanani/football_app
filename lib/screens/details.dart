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
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTeamData();
  }

  Future<void> _fetchTeamData() async {
    try {
      final teamDetails = await _apiService.fetchTeamDetails();
      setState(() {
        _squadDetails = teamDetails['squad'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Players'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Erreur : $_errorMessage'))
              : ListView.builder(
                  itemCount: _squadDetails?.length ?? 0,
                  itemBuilder: (context, index) {
                    final player = _squadDetails?[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: GestureDetector(
                        onTap: () {},
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
                        ).animate().scale(
                              duration: 500.ms,
                              curve: Curves.easeInOut,
                            ),
                      ),
                    );
                  },
                ),
    );
  }
}
